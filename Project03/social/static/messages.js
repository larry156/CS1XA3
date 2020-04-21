/* ********************************************************************************************
   | Handle Submitting Posts - called by $('#post-button').click(submitPost)
   ********************************************************************************************
   */

function submitPostResponse(data,status) {
    if (status == 'success') {
        // reload page to display new Post
        location.reload();
    }
    else {
        alert('failed to submit post' + status);
    }
}

function submitPost(event) {
    let json_data = {  'postContent' : $('#post-text').text() };
    let max_length = 280;
    if (json_data['postContent'].length > max_length) {
        alert("Your post exceeds the " + max_length + " character limit.");
        return;
    }
    let url_path = post_submit_url;
    //alert('Posting ' + json_data['postContent']);
    $.post(url_path, json_data, submitPostResponse);
}

/* ********************************************************************************************
   | Handle Liking Posts - called by $('.like-button').click(submitLike)
   ********************************************************************************************
   */

function submitLikeResponse(data,status) {
    if (status == 'success') {
        // reload page to display new Post
        location.reload();
    }
    else {
        alert('failed to like post' + status);
    }
}

function submitLike(event) {
    //alert('Like Button Pressed');
    // the id of the current button, should be fr-name where name is valid username
    let postID = this.id;
    let json_data = { 'postID' : postID };
    // globally defined in messages.djhtml using i{% url 'social:like_view' %}
    let url_path = like_post_url;

    // AJAX post
    $.post(url_path,
           json_data,
           submitLikeResponse);
}

/* ********************************************************************************************
   | Handle Requesting More Posts - called by $('#more-button').click(submitMore)
   ********************************************************************************************
   */
function moreResponse(data,status) {
    if (status == 'success') {
        // reload page to display new Post
        location.reload();
    }
    else {
        alert('failed to request more posts' + status);
    }
}

function submitMore(event) {
    // submit empty data
    let json_data = { };
    // globally defined in messages.djhtml using i{% url 'social:more_post_view' %}
    let url_path = more_post_url;

    // AJAX post
    $.post(url_path,
           json_data,
           moreResponse);
}

/* ********************************************************************************************
   | Document Ready (Only Execute After Document Has Been Loaded)
   ********************************************************************************************
   */
$(document).ready(function() {
    // handle post submission
    $('#post-button').click(submitPost);
    // handle likes
    $('.like-button').click(submitLike);
    // handle more posts
    $('#more-button').click(submitMore);
});
