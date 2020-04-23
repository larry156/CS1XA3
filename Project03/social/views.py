from django.http import HttpResponse,HttpResponseNotFound
from django.shortcuts import render,redirect,get_object_or_404
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm, PasswordChangeForm
from django.contrib.auth import authenticate, login, logout, update_session_auth_hash
from django.contrib import messages

from . import models

def messages_view(request):
    """Private Page Only an Authorized User Can View, renders messages page
       Displays all posts and friends, also allows user to make new posts and like posts
    Parameters
    ---------
      request: (HttpRequest) - should contain an authorized user
    Returns
    --------
      out: (HttpResponse) - if user is authenticated, will render private.djhtml
    """
    if request.user.is_authenticated:
        user_info = models.UserInfo.objects.get(user=request.user)


        posts = models.Post.objects.all().order_by("-timestamp")
        posts_to_display = request.session.get('num_posts', 1)
        posts = posts[:posts_to_display]

        context = { 'user_info' : user_info
                  , 'posts' : posts }
        return render(request,'messages.djhtml',context)

    request.session['failed'] = True
    return redirect('login:login_view')

def account_view(request):
    """Private Page Only an Authorized User Can View, allows user to update
       their account information (i.e UserInfo fields), including changing
       their password
    Parameters
    ---------
      request: (HttpRequest) should be either a GET or POST
    Returns
    --------
      out: (HttpResponse)
                 GET - if user is authenticated, will render account.djhtml
                 POST - handle form submissions for changing password, or User Info
                        (if handled in this view)
    """
    if request.user.is_authenticated:
        pwd_form = PasswordChangeForm(request.user)
        pwd_invalid = False
        info_form = models.UserInfoForm()
        info_invalid = False

        user_info = models.UserInfo.objects.get(user=request.user)

        if request.method == 'POST':
            pwd_form = PasswordChangeForm(user=request.user, data=request.POST)
            info_form = models.UserInfoForm(request.POST)

            # Changing Password
            if pwd_form.is_valid():
                #print("Changed password")
                request.user.set_password(pwd_form.cleaned_data.get('new_password1'))
                request.user.save()
            elif pwd_form.data.get('old_password'): # Don't display an error message if they're not changing the password
                #print(pwd_form.errors)
                pwd_invalid = True

            # User Info
            if info_form.is_valid():
                #print(info_form.cleaned_data.get('interests'))
                user_info.employment = info_form.cleaned_data.get('employment')
                user_info.location = info_form.cleaned_data.get('location')
                user_info.birthday = info_form.cleaned_data.get('birthday')
                raw_interests = request.POST.get('interests').split(',')
                # clear duplicates
                for i in range(len(raw_interests)):
                    raw_interests[i] = raw_interests[i].strip()
                raw_interests = list(set(raw_interests)) 
                #print(raw_interests)
                for interest in raw_interests:
                    if interest != '' and not user_info.interests.filter(label__iexact=interest).exists():
                        if models.Interest.objects.filter(label__iexact=interest).exists():
                            user_info.interests.add(models.Interest.objects.filter(label__iexact=interest))
                        else:
                            user_info.interests.create(label=interest)
                user_info.save()
            elif info_form.data.get('employment'):
                #print(info_form.errors)
                info_invalid = True
        
        context = { 'user_info' : user_info,
                    'pwd_form' : pwd_form,
                    'pwd_invalid' : pwd_invalid,
                    'info_form' : info_form,
                    'info_invalid' : info_invalid }
        return render(request,'account.djhtml',context)

    request.session['failed'] = True
    return redirect('login:login_view')

def people_view(request):
    """Private Page Only an Authorized User Can View, renders people page
       Displays all users who are not friends of the current user and friend requests
    Parameters
    ---------
      request: (HttpRequest) - should contain an authorized user
    Returns
    --------
      out: (HttpResponse) - if user is authenticated, will render people.djhtml
    """
    if request.user.is_authenticated:
        user_info = models.UserInfo.objects.get(user=request.user)

        people_to_display = request.session.get('people_to_display', 1)
        #print(people_to_display)

        # get people who haven't been befriended already
        all_people = models.UserInfo.objects.all()
        friendship_targets = []
        for person in all_people:
            if person != user_info and not user_info.friends.filter(user=person.user).exists():
                friendship_targets.append(person)
        for person in friendship_targets:
            #print(person.user.username)
            pass

        # get list of pending friend requests to this user
        friend_requests = list(models.FriendRequest.objects.filter(to_user=user_info))
        sent_requests = []
        for person in friendship_targets:
            # disable friend request sending if this user has already sent one to that user, or vice versa
            if models.FriendRequest.objects.filter(from_user=user_info, to_user=person).exists():
                sent_requests.append(person)
            if models.FriendRequest.objects.filter(from_user=person, to_user=user_info).exists():
                sent_requests.append(person)

        context = { 'user_info' : user_info,
                    'all_people' : all_people,
                    'friendship_targets' : friendship_targets,
                    'ppl_to_display' : people_to_display,
                    'friend_requests' : friend_requests,
                    'sent_requests' : sent_requests }

        return render(request,'people.djhtml',context)

    request.session['failed'] = True
    return redirect('login:login_view')

def like_view(request):
    '''Handles POST Request recieved from clicking Like button in messages.djhtml,
       sent by messages.js, by updating the corrresponding entry in the Post Model
       by adding user to its likes field
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute postID,
                                a string of format post-n where n is an id in the
                                Post model

	Returns
	-------
   	  out : (HttpResponse) - queries the Post model for the corresponding postID, and
                             adds the current user to the likes attribute, then returns
                             an empty HttpResponse, 404 if any error occurs
    '''
    postIDReq = request.POST.get('postID')
    if postIDReq is not None:
        # remove 'post-' from postID and convert to int
        postID = int(postIDReq[5:])
        print(postID)

        if request.user.is_authenticated:
            posts = models.Post.objects.all().order_by("-timestamp")
            likedPost = posts[postID]
            if not likedPost.likes.filter(user=request.user).exists():
                likedPost.likes.add(models.UserInfo.objects.get(user=request.user))

            # return status='success'
            return HttpResponse()
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('like_view called without postID in POST')

def post_submit_view(request):
    '''Handles POST Request recieved from submitting a post in messages.djhtml by adding an entry
       to the Post Model
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute postContent, a string of content

	Returns
	-------
   	  out : (HttpResponse) - after adding a new entry to the POST model, returns an empty HttpResponse,
                             or 404 if any error occurs
    '''
    postContent = request.POST.get('postContent')
    user_info = models.UserInfo.objects.get(user=request.user)
    if postContent:
        if request.user.is_authenticated:

            newPost = models.Post(owner=user_info, content=postContent)
            newPost.save()

            # return status='success'
            return HttpResponse()
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('post_submit_view called without postContent in POST')

def more_post_view(request):
    '''Handles POST Request requesting to increase the amount of Post's displayed in messages.djhtml
    Parameters
	----------
	  request : (HttpRequest) - should be an empty POST

	Returns
	-------
   	  out : (HttpResponse) - should return an empty HttpResponse after updating hte num_posts sessions variable
    '''
    if request.user.is_authenticated:
        # update the # of posts dispalyed

        posts_to_display = request.session.get('num_posts', 1)
        request.session['num_posts'] = posts_to_display + 1

        # return status='success'
        return HttpResponse()

    return redirect('login:login_view')

def more_ppl_view(request):
    '''Handles POST Request requesting to increase the amount of People displayed in people.djhtml
    Parameters
	----------
	  request : (HttpRequest) - should be an empty POST

	Returns
	-------
   	  out : (HttpResponse) - should return an empty HttpResponse after updating the num ppl sessions variable
    '''
    if request.user.is_authenticated:
        # update the # of people displayed
        people_to_display = request.session.get('people_to_display', 1)
        request.session['people_to_display'] = people_to_display + 1
        #print("Should be displaying", request.session['people_to_display'], "people.")

        # return status='success'
        return HttpResponse()

    return redirect('login:login_view')

def friend_request_view(request):
    '''Handles POST Request recieved from clicking Friend Request button in people.djhtml,
       sent by people.js, by adding an entry to the FriendRequest Model
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute frID,
                                a string of format fr-name where name is a valid username

	Returns
	-------
   	  out : (HttpResponse) - adds an etnry to the FriendRequest Model, then returns
                             an empty HttpResponse, 404 if POST data doesn't contain frID
    '''
    frID = request.POST.get('frID')
    if frID is not None:
        # remove 'fr-' from frID
        username = frID[3:]

        if request.user.is_authenticated:
            sender = models.UserInfo.objects.get(user=request.user)
            recipient = models.UserInfo.objects.get(user=models.User.objects.get(username=username))
            new_request = models.FriendRequest(to_user=recipient, from_user=sender)
            new_request.save()

            #print(str(sender) + " sent a friend request to " + str(recipient))
            # return status='success'
            return HttpResponse()
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('friend_request_view called without frID in POST')

def accept_decline_view(request):
    '''Handles POST Request recieved from accepting or declining a friend request in people.djhtml,
       sent by people.js, deletes corresponding FriendRequest entry and adds to users friends relation
       if accepted
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute decision,
                                a string of format A-name or D-name where name is
                                a valid username (the user who sent the request)

	Returns
	-------
   	  out : (HttpResponse) - deletes entry to FriendRequest table, appends friends in UserInfo Models,
                             then returns an empty HttpResponse, 404 if POST data doesn't contain decision
    '''
    data = request.POST.get('decision')
    #print(type(data))
    if data:

        if request.user.is_authenticated:

            accepted = data[0] == 'A'
            requester = models.UserInfo.objects.get(user=models.User.objects.get(username=data[2:]))
            me = models.UserInfo.objects.get(user=request.user)
            fr = models.FriendRequest.objects.get(to_user=me,from_user=requester)
            print(fr)
            fr.delete()
            # # also check for any friend requests from me to requester that might exist
            frReverse = models.FriendRequest.objects.filter(to_user=requester,from_user=me)
            if frReverse:
                frReverse.delete()

            # add to friends
            me.friends.add(requester)
            requester.friends.add(me)

            # return status='success'
            #print(data)
            print(accepted, requester)
            return HttpResponse()
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('accept-decline-view called without decision in POST')
