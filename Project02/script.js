$(document).ready(function () {
    // y-offset of the navbar
    var yOffset = $("#navBar").offset().top;
    // y-positions of sections relative to the document
    var highlightOffsetVal = 96;
    var yPosSkills = $("#section-skills").offset().top - highlightOffsetVal;
    var yPosProjects = $("#section-projects").offset().top - highlightOffsetVal;
    var yPosEducation = $("#section-education").offset().top - highlightOffsetVal;
    var yPosExperience = $("#section-experience").offset().top - highlightOffsetVal;
    // Last section of the CV
    var lastSectionBtn = $("#btn-experience");

    var modalVisible = false;

    // Update yPos variables. This should be called by anything that affects the length of the page.
    function setYPos() {
        yPosSkills = $("#section-skills").offset().top - highlightOffsetVal;
        yPosProjects = $("#section-projects").offset().top - highlightOffsetVal;
        yPosEducation = $("#section-education").offset().top - highlightOffsetVal;
        yPosExperience = $("#section-experience").offset().top - highlightOffsetVal;
    }

    // Hide elements if visible, otherwise show them.
    function toggleCollapser() {
        if ($(this).parent().find(".hide-click:visible").length > 0) {
            $(this).parent().find(".hide-click:visible").hide();
            $(this).text(function () {
                return "Expand";
            });
        }
        else {
            $(this).parent().find(".hide-click:hidden").show();
            $(this).text(function () {
                return "Collapse";
            });
        }
        $(this).toggleClass("collapser-visible");
        $(this).toggleClass("collapser-hidden");

        // Collapsing things is going to change the position of some sections, so update the y values accordingly
        setYPos();
        //console.log($(this).parent().find(".hide-click:visible"))
        //console.log($(this).parent().find(".hide-click:hidden"))
    }

    // Collapses or expands all collapsible sections
    function toggleAllCollapsers() {
        // If a collapsible section is visible then hide all of them
        if ($(".view-toggle").hasClass("collapser-visible")) {
            $(".view-toggle").each(function () {
                if ($(this).hasClass("collapser-visible")) {
                    $(this).each(toggleCollapser); // Even though $(this) is only one element, this is the easiest way to call a function on a selector.
                }
            });
        }
        // Otherwise make them all visible
        else {
            $(".view-toggle").each(function () {
                if ($(this).hasClass("collapser-hidden")) {
                    $(this).each(toggleCollapser);
                }
            });
            // Resize images
            resizeAllImages();
        }
    }

    // Sticky navbar
    function stickyNav() {
        if ($(window).scrollTop() >= yOffset) {
            $("#navBar").addClass("navbar-sticky");
        }
        else {
            $("#navBar").removeClass("navbar-sticky");
        }
    }

    // Highlight buttons on navbar based on user's position in the document
    function navHighlight() {
        // Reset theme colours for all navbar items
        $(".w3-bar-item").removeClass("w3-theme");
        //$(".w3-bar-item").removeClass("w3-theme-d3");
        $(".w3-bar-item").addClass("w3-theme-d3");

        // Change colours based on scroll position in document
        if ($(window).scrollTop() < yPosSkills) {
            $("#btn-home").addClass("w3-theme");
            $("#btn-home").removeClass("w3-theme-d3");
        }
        else if ($(window).scrollTop() < yPosProjects) {
            $("#btn-skills").addClass("w3-theme");
            $("#btn-skills").removeClass("w3-theme-d3");
        }
        else if ($(window).scrollTop() < yPosEducation) {
            $("#btn-projects").addClass("w3-theme");
            $("#btn-projects").removeClass("w3-theme-d3");
        }
        else if ($(window).scrollTop() < yPosExperience) {
            $("#btn-education").addClass("w3-theme");
            $("#btn-education").removeClass("w3-theme-d3");
        }
        else {
            lastSectionBtn.addClass("w3-theme");
            lastSectionBtn.removeClass("w3-theme-d3");
        }
    }

    // Dynamically resize the images of project cards to fit in with the text.
    function resizeImage() {
        var maxWidth = "500px";
        // Get dimensions of the text container
        var textHeight = $(this).parent().find(".w3-justify").height(); // The text container is the only element in this context with the w3-justify class
        
        var img = $(this).parent().find(".w3-image");
        var imgContainer = img.parent();
        // Make sure there's enough space so that the image doesn't get squished by resizing
        if (textHeight < imgContainer.width()) {
            img.css("height", textHeight);
            img.css("width", "auto");
        }
        else {
            img.css("max-width", "100%");
            img.css("height", "auto");
        }
        //console.log(textHeight);
        //console.log(imgContainer.width());
        //console.log(img.css("max-width"));

        // Adjust yPos to account for image resizing.
        setYPos();
    }

    // This function calls resizeImage() on all project-collapser elements.
    function resizeAllImages() {
        $(".project-collapser").each(resizeImage);
    }

    // Toggles the visibility of modals
    function toggleModal() {
        //console.log("Trying to toggle modal");
        // Hide the modal if it's already shown.
        if (modalVisible == true || !$(this).hasClass("expandable-image")) {
            $(".w3-modal").hide();
            modalVisible = false;
        }
        // Otherwise show it.
        else {
            modalVisible = true;
            var myID = "#" + $(this).attr("id");
            $(".w3-modal" + myID).show();
        }
    }

    $(".view-toggle").click(toggleCollapser);
    $("#btn-collapse-all").click(toggleAllCollapsers);
    $(".project-collapser").click(resizeImage);
    $(".expandable-image").click(toggleModal);
    $(".w3-modal").click(toggleModal);
    //$(".project-collapser").ready(resizeImage);
    $(window).scroll(stickyNav);
    $(window).scroll(navHighlight);
    $(window).resize(resizeAllImages);
    $(window).resize(setYPos);

    // If the user refreshes the page, the navbar won't update until they scroll. This avoids that issue.
    stickyNav();
    navHighlight();
    resizeAllImages();
});