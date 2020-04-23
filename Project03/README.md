# CS 1XA3 Project03 - yaol13

## Usage

Install conda enivronment by following the instructions [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/), or
[here](https://gist.github.com/kauffmanes/5e74916617f9993bc3479f401dfec7da) if you use Windows Subsystem for Linux.

Once Conda is installed, run the following commands in your shell terminal to activate the Django environment:

```bash
conda create -n djangoenv python=3.7
conda activate djangoenv
```

Run locally with

```bash
python manage.py runserver localhost:8000
```

Run on mac1xa3.ca with

```bash
python manage.py runserver localhost:10114
```

Note: Make sure you are in the /CS1XA3/Project03/ directory, which is where manage.py is located. The site is accessible from localhost:[port]/e/yaol13/, where [port] is either
8000 on your local machine, or 10114 on mac1xa3.ca.

Once you're on the site, log in with username "TestUser", password "1234" or create your own user account.

## Objective 01 - Login & Signup

**Description**:

The login functionality has been left more or less identical to the given template. It is displayed in `login.djhtml`, and is rendered by `login_view`.
Logging in makes a POST request to `/e/yaol13/` which is handled by `login_view` in `login/views.py`, and if the user successfully logs in, they are redirected to `/e/yaol13/social/messages/`.

The signup/user creation functionality utilizes Django's built-in `UserCreationForm` as a base, but the HTML has been altered, which you can see in `signup.djhtml`.
`signup.djhtml` is rendered by `signup_view`, and the HTML form makes a POST request to `/e/yaol13/signup`, which is handled by `signup_view` in `login/views.py`.
If the form is valid, a new UserInfo object is created with the given username and password, and the new user is automatically logged in.

**Exceptions**:

If the login request fails to authenticate, the user is redirected back to `login.djhtml`.
If the form data in the POST to `/e/yaol13/signup/` is invalid, an error message is displayed in `signup.djhtml`, and a new user is *not* created.

**Note**:

It appears that usernames are case-sensitive, so be mindful of that when logging in or signing up. The password fields in the HTML forms will not show whatever text
has been entered. Users are required to fill out each field in these forms before submitting.

## Objective 02 - User Profile & Interests

**Description**:

A user's basic info (username, employment, location, birthday, and interests) is displayed in the `left_column` block of `social_base.djhtml`, and is rendered by any view that utilizes a template based on this file (i.e. `messages_view`, `people_view`, and `account_view`). The current user's userinfo is passed to the template's context, and this userinfo object is used to display their info as text on the webpage. Each interest of a user is displayed as a tag in the "Interests" card.

**Note**:

From this point on in the README, all views are assumed to be found in `social/views.py`.

**Exceptions**:

If a user has not set their employment, location, or birthday, those sections will say "Unspecified", "Unspecified", and "None", respectively. If a user has no interests, the
"Interests" card will still appear on the webpage, but will be empty.

## Objective 03 - Account Settings Page

**Description**:

The account settings page is displayed in `account.djhtml`, and is rendered by `account_view`. In the `middle_column` block, there are two HTML forms that allow a user
to change their password, and update their info. These forms are named `pwd_form`, and `info_form`, respectively. `pwd_form` is based on the built-in `PasswordChangeForm`
provided by Django, while `info_form` is based on the `UserInfoForm` class implemented in `social/models.py`.

Changing a user's password has the same restrictions as creating a new user's password, and these restrictions are displayed on the form. Submitting the form sends a
POST request to `/e/yaol13/account/`, and is handled by `account_view`. If the POST data is valid, the user's password is changed. If the data is invalid, and the
`old_password` field is *not* empty, an error message is displayed on the webpage, underneath the form. (This means that the error message will not show up unless
the user has attempted to change their password). Each field of the form is a password field, so any text entered will be hidden, and each field is required.

`info_form` consists of 4 fields: 2 text fields for Employment and Location, 1 date field for Birthday, and 1 text area for Interests. Employment, Location, and Birthday are
required fields, while Interests can be left empty. Submitting this form makes a POST request to `/e/yaol13/account/`, which is handled by `account_view`.
If the POST data is invalid, and the `employment` field is *not* empty, an error message is displayed underneath the form. (This means that the error message will not show up
unless the user has attempted to update their info). Otherwise, the user's employment, location, and birthday are each set to the corresponding data in the POST request.
The `interests` field of the form is split into a list using commas as the delimiter. Each element of this list is then stripped of any whitespace characters, then added
to the user's interests if that interest is not already present (case-insensitive).

**Exceptions**:

For data in `pwd_form` to be valid, the "Old Password" field must match a user's current password, "New Password" must fulfill the given requirements, and
"Confirm Password" must match "New Password". If the user is not authenticated, then they will be redirected to the login page.

**Note**:

Upon changing their password, users will remain logged in. If no interests are entered in `info_form`, then no interests will be added.

## Objective 04 - Displaying People List

**Description**:

The people page is displayed in `people.djhtml` and is rendered bu `people_view`. It can be accessed by clicking the people icon on the Navbar.
Upon loading, the page retrieves a list of all users that are not the current user or a friend of the current user, called `friendship_targets`. It then retrieves
a list, `friend_requests`, of all FriendRequest objects to the current user, and another list, `sent_requests`, of all friend requests involving the current user
(i.e. either to or from the user). These lists are then passed to `people.djhtml`.

In the `people.djhtml` template, the middle column displays all users in `friendship_targets` using a for loop. Using the session variable `people_to_display`, which
is an integer starting at 1, the page will display that many users. At the bottom is a button labelled "More", which, when clicked, makes an empty AJAX POST to
`more_ppl_view`, which increments the session variable `people_to_display` by 1 and returns an empty HTTP response (which, in effect, reloads the page).

**Exceptions**:

If the amount of people that can be displayed in total is lower than `people_to_display`, the page will show everyone that it can.
(e.g. if the user clicks "More" 5 times, but there are only 3 users, the page will only show 3 users.)
If the user is not authenticated, then they will be redirected to the login page.

## Objective 05 - Sending Friend Requests

**Description**:

Each user rendered in `people.djhtml` is displayed on a card, which has a button allowing the current user to send a friend request to them.
The current user will be unable to send a friend request if there already exists a FriendRequest object involving the two users.
Upon clicking the button, an AJAX POST request is made to `friend_request_view` containing the button's ID,
which will be of the form `fr-<NAME>`, where `<NAME>` is the recipient's username. A new FriendRequest object is then created, with
`to_user` and `from_user` being the recipient and sender of the friend request, respectively, and the page is reloaded.
All friend request buttons have a jQuery event attached to them in `people.js`, and the POST is sent using the `friendRequest` and `frResponse` functions
defined within that file.

In the right column of `people.djhtml`, a list of all friend requests to the current user (i.e. the friend request's `to_user` is the current user) is displayed.
Each friend request contains the sender's username and picture, as well as two buttons allowing the current user to either accept or decline the request.

**Note**:

"A FriendRequest object involving the two users" clarification: Say, for example, Jimmy sends a friend request to Timmy.
Timmy cannot, then, send another friend request to Jimmy, as there is already a friend request involving Jimmy and Timmy.

As a user's existing friends are not displayed in the list of people, a user is unable to send friend requests to their friends.
Likewise, users cannot send friend requests to themselves.

**Exceptions**:

If, for whatever reason, sending the AJAX POST fails, an alert is displayed informing the user of this failure.
If the user is not authenticated, then they will be redirected to the login page.

## Objective 06 - Accepting/Declining Friend Requests

**Description**:

When a user either accepts or declines a friend request using the buttons mentioned above, an AJAX POST is made to `accept_decline_view`
containing the appropriate button's ID, which will be either `A-<NAME>`, or `D-<NAME>`, where `<NAME>` is the username of whoever sent the friend request.
This functionality is handled within `people.js`, by the `acceptDeclineRequest` and `adResponse` functions.

In `accept_decline_view`, the script determines whether the user accepted or declined the friend request based on the data sent in the POST:

```python
accepted = data[0] == 'A'
```

(`data` is a string containing the POST data. If the user accepted the request, then the first character would be "A".)
The script then gets the UserInfo objects of whoever sent the friend request (`requester`), and the current user (`me`), and deletes
the friend request from `requester` to `me`, as well as the friend request from `me` to `requester`, if that exists for whatever reason.
Finally, both users are added to eachother's friend lists (i.e. the `friends` field in their UserInfo), and the page is reloaded.

**Exceptions**:

If, for whatever reason, sending the AJAX POST fails, an alert is displayed informing the user of this failure.
If the user is not authenticated, then they will be redirected to the login page.

## Objective 07 - Displaying Friends

**Description**:

A user's friends are displayed in the right column of `messages.djhtml`, which is rendered by `messages_view`.
`messages_view` passes the current user's UserInfo to the Django template through the context dictionary, and the template
displays each friend by iterating through the current user's `friends` field using a for loop.

Each friend of the user is displayed on a card, labelled "Friend", which shows their username and avatar.

**Exceptions**:

If the current user has no friends, then the right column of `messages.djhtml` will just be empty.
If the user is not authenticated, then they will be redirected to the login page.

## Objective 08 - Submitting Posts

**Description**:

On the top of the middle column of `messages.djhtml`, there is a text field and submit button that allows users to write and submit posts.
Clicking the submit button runs the `submitPost` function in `messages.js`, which gets the content of that text field and sends it to
`post_submit_view` in an AJAX POST.

`post_submit_view` receives this data, gets the UserInfo of the current user, and, if the social media post isn't empty, creates
a new Post object with the `owner` being the current user, and the `content` being the data of the HTTP POST. This new Post is then
saved to the database, and the page is reloaded.

**Exceptions**:

Submitting a post will fail if the text field is empty. To the user, this will appear as if nothing has happened.
If the length of the post exceeds the 280 character limit, an alert is displayed on the user's screen, and no POST request is made.
If, for whatever reason, sending the AJAX POST fails, an alert is displayed informing the user of this failure.
If the user is not authenticated, then they will be redirected to the login page.

## Objective 09 - Displaying Post List

**Description**:

Any posts in the database will be displayed in the middle column of `messages.djhtml`, below the form for submitting posts.
These posts are ordered chronologically, with the newest post appearing first. Only one post is displayed at first; if the user clicks on
the "More" button at the bottom of the page, then more posts will be loaded. Each click of the button results in another post being loaded.

This functionality is implemented in `messages_view`, and `more_posts_view`. Within `messages_view` gets *n* Post objects, (where *n* is
the number of posts to display), and passes them to `messages.djhtml` as a list of Posts. This list is ordered by the post's timestamp,
so the newest post is first in the list. *n* is implemented as the session variable `people_to_display`, which starts at 1, and is incremented by 1
each time a POST request is made to `more_posts_view`. Each time the user clicks the button labelled "More" on the webpage, an empty AJAX POST is made
to `more_posts_view`.

In `messages.djhtml`, a for loop renders each post in the list passed by `messages_view`. Each post displays the avatar and username of whoever
submitted the post, as well as it's content, a timestamp (i.e. when the post was made), a button to "Like" the post, and the number of likes the post has.

**Exceptions**:

If no posts have been made, then the page will display no posts. Likewise, if, for example, the user presses the "More" button 10 times (so `people_to_display`
would be 11), but there are only 5 posts, then only 5 posts will be displayed.
If, for whatever reason, sending the AJAX POST fails, an alert is displayed informing the user of this failure.
If the user is not authenticated, then they will be redirected to the login page.

## Objective 10 - Liking Posts (and Displaying Like Count)

**Description**:

Each object of the Post model has a `likes` field, which is a list of UserInfo objects representing the users who have liked the post.
`messages.djhtml` uses the length of this list to show how many people have liked the post, like so:

```html
<span class="w3-button w3-theme-d1 w3-margin-bottom">{{ post.likes.count }} Likes</span>
```

When the user "likes" a post by pressing the Like button, an AJAX POST is made to `like_view` containing the ID of the button.
This ID is of the form `post-<i>`, where `<i>` is the index of that particular post in the list of all Post objects, in reverse chronological order (newest first).
In `like_view`, the script retrieves the liked post using that index, and adds the current user's UserInfo to the post's `likes` field, if it is not already there.
The page is then reloaded.

If the current user has already liked a post, then the "Like" button will be disabled for that post, and its text will be changed to "Liked".
This, in addition to the check mentioned above, prevents the user from "double-liking" a post.

**Exceptions**:

If, for whatever reason, sending the AJAX POST fails, an alert is displayed informing the user of this failure.
If the user is not authenticated, then they will be redirected to the login page.

## Objective 11 - Create a Test Database

**Description**:

This section is a list of all test users of the site. You can see them below.

```
Username: TestUser
Password: 1234
```

```
Username: Faux_Pas
Password: RepulsiveConcept
```

```
Username: Brindleberry
Password: megafish
```

```
Username: SuperFriend
Password: magicoffriendship
```

```
Username: AnotherTester
Password: somepassword
```

```
Username: Jimmy_Neutron
Password: brainblast
```

```
Username: Bot001
Password: beepboop
```
