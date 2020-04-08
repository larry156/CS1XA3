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

## Objective 01

**Description**:

this feature is displayed in something.djhtml which is rendered by
some_view
it makes a POST Request to from something.js to /e/macid/something_post
which is handled by someting_post_view

**Exceptions**:

If the /e/macid/something_post is called without arguments is redirects
to login.djhtml

## Objective 02
