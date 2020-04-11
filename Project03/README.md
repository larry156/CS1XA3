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
`python manage.py runserver localhost:8000`
Run on mac1xa3.ca with
`python manage.py runserver localhost:10114`

Note: Make sure you are in the /CS1XA3/Project03/ directory, which is where manage.py is located. The site is accessible from localhost:[port]/e/yaol13/, where [port] is either
8000 on your local machine, or 10114 on mac1xa3.ca.

Once you're on the site, log in with username "TestUser", password "1234"

## Objective 01 - Login & Signup

**Description**:

The login functionality has been left more or less identical to the given template. It is displayed in `login.djhtml`, and is rendered by `login_view`.
Logging in makes a POST request to `/e/yaol13/` which is handled by `login_view`, and if the user successfully logs in, they are redirected to `/e/yaol13/social/messages/`.

The signup/user creation functionality utilizes Django's built-in `UserCreationForm` as a base, but the HTML has been altered, which you can see in `signup.djhtml`.
`signup.djhtml` is rendered by `signup_view`, and the HTML form makes a POST request to `/e/yaol13/signup`, which is handled by `signup_view`.
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
"Confirm Password" must match "New Password".

**Note**:

Upon changing their password, users will remain logged in. If no interests are entered in `info_form`, then no interests will be added.