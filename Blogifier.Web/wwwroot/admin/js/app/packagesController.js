var packagesController = function (dataService) {
    var obj = {};
    var packages = [];

    function enable(id) {
        dataService.put('blogifier/api/packages/enable/' + id, obj, done, fail);
    }

    function disable(id) {
        dataService.put('blogifier/api/packages/disable/' + id, obj, done, fail);
    }

    function done(data) {
        toastr.success('Updated');
        setTimeout(function () {
            window.location.href = getUrl('admin/packages/widgets');
        }, 2000);
    }

    function fail() {
        $('.loading').fadeOut();
        toastr.error('Failed');
    }

    function showInfo(id) {
        dataService.get('blogifier/api/packages/' + id, infoCallback, fail);
        return false;
    }

    function infoCallback(data) {
        $('#packageInfoLabel').html(data.title);

        $('.bf-package-info-cover').find("img").attr('src', data.cover);
        $('.bf-package-info-logo').attr('src', data.icon);
        $('.bf-package-info-title').html(data.title);
        $('.bf-package-info-desc').html(data.description);

        $('.bf-package-info-version').html(data.version);
        $('.bf-package-info-date').html(getDate(data.lastUpdated));
        $('.bf-package-info-developer').html(data.author);

        $('#packageInfo').modal();
    }

    return {
        enable: enable,
        disable: disable,
        showInfo: showInfo,
        packages: packages
    }
}(DataService);

$('#packageInfo').on('show.bs.modal', function (event) {

    var button = $(event.relatedTarget)
    var modalPackage_Title = button.data('title')

    var items = packagesController.packages;

    for (i = 0; i < items.length; i++) {
        var item = items[i];
        var date = new Date(item.LastUpdated);

        if (item && item.Title == modalPackage_Title) {
            var modal = $(this);
            modal.find('.bf-package-info .bf-package-info-title').text(item.Title);
            modal.find('.bf-package-info .bf-package-info-desc').text(item.Description);
            modal.find('.bf-package-info .bf-package-info-logo').attr("src", item.Icon);
            modal.find('.bf-package-info .bf-package-info-cover img').attr("src", item.Cover);
            modal.find('.bf-package-info .bf-package-info-version').text(item.Version);
            modal.find('.bf-package-info .bf-package-info-date').text(getMonthName(date.getMonth()) + " " + date.getDate() + ", " + date.getFullYear());
            //modal.find('.bf-package-info .bf-package-info-installs').text(modalPackage_Installs)
            modal.find('.bf-package-info .bf-package-info-developer').text(item.Author);
        }
    }
});
