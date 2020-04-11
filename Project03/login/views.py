from django.http import HttpResponse,HttpResponseNotFound
from django.shortcuts import render,redirect
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm, PasswordChangeForm
from django.contrib.auth import authenticate, login, logout, update_session_auth_hash
from django.contrib import messages

from social import models

def login_view(request):
    """Serves login.djhtml from /e/yaol13/ (url name: login_view)
    Parameters
    ----------
      request: (HttpRequest) - POST with username and password or an empty GET
    Returns
    -------
      out: (HttpResponse)
                   POST - authenticate, login and redirect user to social app
                   GET - render login.djhtml with an authentication form
    """
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request,user)
            request.session['failed'] = False
            return redirect('social:messages_view')
        else:
            request.session['failed'] = True

    form = AuthenticationForm(request.POST)
    failed = request.session.get('failed',False)
    context = { 'login_form' : form,
                'failed' : failed }

    return render(request,'login.djhtml',context)

def logout_view(request):
    """Redirects to login_view from /e/yaol13/logout/ (url name: logout_view)
    Parameters
    ----------
      request: (HttpRequest) - expected to be an empty get request
    Returns
    -------
      out: (HttpResponse) - perform User logout and redirects to login_view
    """
    # TODO Objective 4 and 9: reset sessions variables

    # logout user
    logout(request)

    return redirect('login:login_view')

def signup_view(request):
    """Serves signup.djhtml from /e/yaol13/signup (url name: signup_view)
    Parameters
    ----------
      request : (HttpRequest) - expected to be an empty get request
    Returns
    -------
      out : (HttpRepsonse)
                   POST - validate, create user account, and redirect to login page
                   GET - render signup.djhtml with a user creation form form
    """
    context = { 'signup_form' : None, 'invalid_form' : False }
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        #print(form)
        if form.is_valid():
            print("Creating user")
            uname = form.cleaned_data.get('username')
            pword = form.cleaned_data.get('password1')
            models.UserInfo.objects.create_user_info(username=uname,password=pword)
            user = authenticate(request, username=uname, password=pword)
            if user is not None:
                login(request,user)
                request.session['failed'] = False
                return redirect('social:messages_view')
            else:
                request.session['failed'] = True
        else:
            context['invalid_form'] = True
    else:
        form = UserCreationForm()
    context['signup_form'] = form
    return render(request,'signup.djhtml',context)
