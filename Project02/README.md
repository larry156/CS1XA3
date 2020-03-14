# CS 1XA3 Project02 - yaol13

## Overview

This webpage is Larry Yao's custom CV.

## Design

**Description**: I made the following design choices ...

## Custom Javascript Code -- Collapsible Sections

**Description**: This feature allows the user to show or hide different sections of the CV, allowing me to describe
different aspects in detail without making the webpage too cluttered. If an HTML element with the "view-toggle" class
is clicked (usually a button), the script looks for any element that shares a parent with the button and has the "hide-click" class.
If there is at least one visible element that satisfies those conditions, the script hides all visible elements that also satisfy those conditions.
Otherwise, it displays them if they are hidden.

## Custom Javascript Code -- Sticky Navigation Bar

**Description**: This feature makes the webpage's navigation bar "stick" to the top of the window when the user scrolls past it,
allowing them to easily navigate to different sections of the page. The script will also highlight the section that the user is currently
browsing on the navigation bar. The navigation bar also includes a button that collapses or expands all collapsible sections.

**Reference**: stickyNav() code was modified from [this w3schools tutorial](https://www.w3schools.com/howto/howto_js_navbar_sticky.asp) to use jQuery instead.

## HTML/CSS References

- This page uses W3.CSS from [this template](https://www.w3schools.com/w3css/tryw3css_templates_teal.htm).
