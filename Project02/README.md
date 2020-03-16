# CS 1XA3 Project02 - yaol13

<!-- Note: I decided against using non-breaking spaces for indentation, because it did not work well with the way GitHub wraps text, and looked very bad. -->
<!-- See this image https://media.discordapp.net/attachments/666016120293163051/688888790428680230/unknown.png for an example. -->

## Overview

This webpage is my (Larry Yao) custom CV. It contains information about my skills, past projects & experience, as well as where I've studied.

## Design

**Description**:

For this CV, I tried to design it to have a more simplistic and "professional" appearance. For the CSS, I used the W3CSS template, as well as a teal theme on top of that
because I thought it looked nice, while not being overly flashy and gimmicky.

I decided to have an always-visible navbar on the page so that viewers will be able to tell
where they are on the page, and to make navigating to the various CV sections a bit easier. Within each section, I used the `w3-card` class to give the page a sense of depth,
as well as to make it look more modular where it makes sense to do so. I also made it so that you can collapse various elements/sections of the CV in order to reduce clutter.

## Custom Javascript Code -- Collapsible Sections

**Description**:

This feature allows the user to show or hide different sections of the CV, allowing me to describe
different aspects in detail without making the webpage too cluttered. If an HTML element with the "view-toggle" class
is clicked (usually a button), the script looks for any element that shares a parent with the button and has the "hide-click" class.
If there is at least one visible element that satisfies those conditions, the script hides all visible elements that also satisfy those conditions.
Otherwise, it displays them if they are hidden.

**Implementation**:

Feature is implemented in the `toggleCollapser()` and `toggleAllCollapsers()` functions in script.js

## Custom Javascript Code -- Sticky Navigation Bar

**Description**:

This feature makes the webpage's navigation bar "stick" to the top of the window when the user scrolls past it,
allowing them to easily navigate to different sections of the page. The script will also highlight the section that the user is currently
browsing on the navigation bar. The navigation bar also includes a button that collapses or expands all collapsible sections.

**Implementation**:

Feature is implemented in the `stickyNav()`, `navHighlight()`, and `setYPos()` functions in script.js

**Reference**:

- `stickyNav()` code was modified from [this w3schools tutorial](https://www.w3schools.com/howto/howto_js_navbar_sticky.asp) to use jQuery instead.

## Custom Javascript Code -- Dynamic Image Resizing

**Description**:

This feature dynamically resizes the images of the three projects that are described in the CV so that the image height matches the height of the text container beside it.
runs when the window is resized, as well as when one of the project sections is collapsed or expanded by the user. Checks are also included to make sure the image's aspect ratio
maintained, so that it doesn't get squished because the page isn't wide enough to draw the image properly.

**Implementation**:

Feature is implemented in the `resizeImage()`, and `resizeAllImages()` functions in script.js

## Custom Javascript Code -- Image Modals

**Description**:

Each image in the projects section has a modal associated with it (i.e. shares the same id attribute) which is hidden by default.
When a visitor clicks on one of these images, the modal is displayed, allowing them to see the image more clearly.
Afterwards, when the visitor clicks anywhere on the page (technically only when they click on the modal, but the modal takes up the entire page so
practically it has the same effect), the modal is hidden again.

**Implementation**:

Feature is implemented in the `toggleModals()` function in script.js

## HTML/CSS References

- This page uses W3.CSS from [this template](https://www.w3schools.com/w3css/tryw3css_templates_teal.htm).
- HTML for the Image Modals feature was modified from [w3schools](https://www.w3schools.com/w3css/w3css_modal.asp).

## Other JS References

- The [jQuery API documentation](https://api.jquery.com/) was referenced when writing custom features.
- [This list](https://www.w3schools.com/jquery/jquery_ref_selectors.asp) of jQuery selectors was used as a reference.
