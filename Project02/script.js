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

        // Collapsing things is going to change the position of some sections, so update the y values accordingly
        yPosSkills = $("#section-skills").offset().top - highlightOffsetVal;
        yPosProjects = $("#section-projects").offset().top - highlightOffsetVal;
        yPosEducation = $("#section-education").offset().top - highlightOffsetVal;
        yPosExperience = $("#section-experience").offset().top - highlightOffsetVal;
        //console.log($(this).parent().find(".hide-click:visible"))
        //console.log($(this).parent().find(".hide-click:hidden"))
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
        $(".w3-bar-item").removeClass("w3-theme-l1");
        $(".w3-bar-item").removeClass("w3-theme");
        $(".w3-bar-item").addClass("w3-theme");

        // Change colours based on scroll position in document
        if ($(window).scrollTop() < yPosSkills) {
            $("#btn-home").addClass("w3-theme-l1");
            $("#btn-home").removeClass("w3-theme");
        }
        else if ($(window).scrollTop() < yPosProjects) {
            $("#btn-skills").addClass("w3-theme-l1");
            $("#btn-skills").removeClass("w3-theme");
        }
        else if ($(window).scrollTop() < yPosEducation) {
            $("#btn-projects").addClass("w3-theme-l1");
            $("#btn-projects").removeClass("w3-theme");
        }
        else if ($(window).scrollTop() < yPosExperience) {
            $("#btn-education").addClass("w3-theme-l1");
            $("#btn-education").removeClass("w3-theme");
        }
        else {
            lastSectionBtn.addClass("w3-theme-l1");
            lastSectionBtn.removeClass("w3-theme");
        }
    }

    $(".view-toggle").click(toggleCollapser);
    $(window).scroll(stickyNav);
    $(window).scroll(navHighlight);
});