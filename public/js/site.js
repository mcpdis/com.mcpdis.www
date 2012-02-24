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

    if ($("#apps").length == 1) {
        $.each($("#apps tbody tr"), function() {
            var $tr = $(this);

            if ($tr.find("ol > li").length > 3) {
                $("li:nth-child(1), li:nth-child(2), li:nth-child(3)", $tr).
                    addClass("fixed");

                $("li:not(.fixed)", $tr).addClass("hide");

                $("ol", $tr).after("<a href='#show-all'>Show all &raquo;</a>");
            }
        });

        $("a[href*='#show-all']").live("click", function() {
            var $a = $(this),
                $li = $a.parents("tr").find("li:not(.fixed)");

            $li.toggleClass("hide");

            if ($a.text().match(/Show/)) {
              $a.html("&laquo; Hide")
            } else {
              $a.html("Show all &raquo;")
            }

            return false;
        });
    }
})(jQuery);
