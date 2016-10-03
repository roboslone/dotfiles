$([IPython.events]).on("app_initialized.NotebookApp", function () {
    $('div#header-container').hide();
    $('div#maintoolbar').hide();
    $('div#notebook-container').css({boxShadow: 'none', backgroundColor: '#eeeeee'})
});
