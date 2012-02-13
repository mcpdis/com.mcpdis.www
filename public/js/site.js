(function($) {
    $("a[href*='#check-all']").click(function() {
        $(":checkbox").attr("checked", true);
        return false;
    });

    $("a[href*='#uncheck-all']").click(function() {
        $(":checkbox").removeAttr("checked");
        return false;
    });

    $("form#download-form").submit(function() {
        var $this = $(this), $btn = $this.find(".form-actions");

        if ($(":checkbox:checked").length === 0) {
            $(".alert.alert-error").remove();

            $btn.before("<div class='alert alert-error'>" +
                        "You need to select at least one formula.</div>");

            return false;
        } else {
            $("#before-download, #after-download").toggleClass("hide");
            return true;
        }
    });
})(jQuery);
