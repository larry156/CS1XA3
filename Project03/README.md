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

It appears that usernames are case-sensitive, so be mindful of that when logging in or signing up.

## Objective 02
