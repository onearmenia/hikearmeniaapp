$(document).ready(function () {

    $('.select-all').click(function (e) {
        if ($(this).is(':checked')) {
            $('.trail-checkbox').prop('checked', true)
        }
        else {
            $('.trail-checkbox').prop('checked', false);
        }

    })
    $(".sortable").sortable({
        handle: ".handle",
        connectWith: ".sortable1"
    }).disableSelection();
    if ($('#usersTable').length) {
        $.ajax({
            url: '/ajax-action/get-users',
            success: function (data) {
                users = data.users;
                i=0;
                usersTable = $('#usersTable table').DataTable({
                        responsive: true,
                        pageLength: 25,
                        bLengthChange: false,
                        sPaginationType: 'full_numbers',
                        data: users,
                        columns: [
                            {
                                "data": function () {
                                    i++;
                                    return i;
                                }
                            },
                            {"data": "name"},
                            {"data": "status"},
                            {"data": "type"},
                            {"data": "action"}

                        ],

                    }
                )
            }
        });

        $('#usersTable table').on('click', 'tr', function () {
            document.location.href = "/admin/edit-user/" + usersTable.row(this).data()['user_id']
        });
    }
    if ($('#accommodationsTable').length) {
        $.ajax({
            url: '/ajax-action/get-accommodations',
            success: function (data) {
                users = data.accommodations;

                accommodationsTable = $('#accommodationsTable table').DataTable({
                        responsive: true,
                        pageLength: 25,
                        bLengthChange: false,
                        sPaginationType: 'full_numbers',
                        data: users,
                        columns: [
                            {"data": "id"},
                            {"data": "name"},
                            {"data": "email"},
                            {"data": "url"},
                            {"data": "status"},
                            {"data": "action"}

                        ],

                    }
                )
            }
        });

        $('#accommodationsTable table').on('click', 'tr', function () {
            document.location.href = "/admin/edit-accommodation/" + accommodationsTable.row(this).data()['id']
        });
    }
    if ($('#guidesTable').length) {
        $.ajax({
            url: '/ajax-action/get-guides',
            success: function (data) {
                users = data.guides;
                i = 0;
                guidesTable = $('#guidesTable table').DataTable({
                        responsive: true,
                        pageLength: 25,
                        bLengthChange: false,
                        sPaginationType: 'full_numbers',
                        data: users,
                        columns: [
                            {
                                "data": function () {
                                    i++;
                                    return i;
                                }
                            },
                            {"data": "name"},
                            {"data": "email"},
                            {"data": "phone"},
                            {"data": "rating"},
                            {"data": "status"},
                            {"data": "action"}

                        ],

                    }
                )
            }
        });

        $('#guidesTable table').on('click', 'tr', function () {
            document.location.href = "/admin/edit-guide/" + guidesTable.row(this).data()['id']
        });
    }
    if ($('#trailsTable').length) {
        $.ajax({
            url: '/ajax-action/get-trails',
            success: function (data) {
                users = data.trails;

                trailsTable = $('#trailsTable table').DataTable({
                        responsive: true,
                        pageLength: 25,
                        bLengthChange: false,
                        sPaginationType: 'full_numbers',
                        data: users,
                        columns: [
                            {"data": "id"},
                            {"data": "name"},
                            {"data": "region"},
                            {"data": "number_of_guides"},
                            {"data": "number_of_accommodations"},
                            {"data": "status"},
                            {"data": "action"}

                        ],

                    }
                )
            }
        });

        $('#trailsTable table').on('click', 'tr', function () {
            document.location.href = "/admin/edit-trail/" + trailsTable.row(this).data()['id']
        });
    }
    if ($('#trailReviewsTable').length) {
        $.ajax({
            url: '/ajax-action/get-trail-reviews',
            success: function (data) {
                users = data.trail_reviews;
                i = 0;
                trailReviewsTable = $('#trailReviewsTable table').DataTable({
                        responsive: true,
                        pageLength: 25,
                        bLengthChange: false,
                        sPaginationType: 'full_numbers',
                        data: users,
                        columns: [
                            {
                                "data": function () {
                                    i++;
                                    return i;
                                }
                            },
                            {"data": "trail_name"},
                            {"data": "rating"},
                            {"data": "user_name"},
                            {"data": "status"},
                            {"data": "action"}

                        ],
                        "columnDefs": [
                            {className: "rating", "targets": [2]}
                        ]

                    }
                )
            }
        });

        $('#trailReviewsTable table').on('click', 'tr', function () {
            document.location.href = "/admin/edit-trail-review/" + trailReviewsTable.row(this).data()['id']
        });
    }
    if ($('#guideReviewsTable').length) {
        $.ajax({
            url: '/ajax-action/get-guide-reviews',
            success: function (data) {
                users = data.guide_reviews;
                i = 0;
                guideReviewsTable = $('#guideReviewsTable table').DataTable({
                        responsive: true,
                        pageLength: 25,
                        bLengthChange: false,
                        sPaginationType: 'full_numbers',
                        data: users,
                        columns: [
                            {
                                "data": function () {
                                    i++;
                                    return i;
                                }
                            },
                            {"data": "guide_name"},
                            {"data": "rating"},
                            {"data": "user_name"},

                            {"data": "status"},
                            {"data": "action"}

                        ],
                        "columnDefs": [
                            {className: "rating", "targets": [2]}
                        ]

                    }
                )
            }
        });

        $('#guideReviewsTable table').on('click', 'tr', function () {
            document.location.href = "/admin/edit-guide-review/" + guideReviewsTable.row(this).data()['id']
        });
    }
    $(".order").resizable({
        minHeight: 50,
        maxHeight: 50
    });

    //loop over all required fields
    $(".ajaxForm button[type=submit]").on('click', function () {
        var form = $(this).closest('form');
        form.find(':input[required]').each(function () {
            if ($(this).val() == '') {
                var tabId = $(this).closest('.tab-pane').attr('id');
                var tabTitle = '';
                if (tabId) {
                    tabTitle = $('.nav-tabs a[href=#' + tabId + ']').find('span').html();

                }

                var label = $(this).parent().parent().find('label.label').html();
                if (!label) {
                    label = "";
                }
                showDangerAlert('Please complete the required field ' + label + " " + tabTitle);
                $(this).focus();
            }
        });
    });
    // --------------------- Drag-n-drop  Start ------------------------------
    var cols = $('.draggable .imageBox');
    cols.each(function () {
        $(this).on('dragstart', handleDragStart);
        $(this).on('dragenter', handleDragEnter);
        $(this).on('dragover', handleDragOver);
        $(this).on('dragleave', handleDragLeave);
        $(this).on('drop', handleDrop);
        $(this).on('dragend', handleDragEnd);
    });

    var dragSrcEl = null;

    function handleDragStart(e) {
        // Target (this) element is the source node.
        //this.style.opacity = '0.4';

        dragSrcEl = this;

        e.originalEvent.dataTransfer.effectAllowed = 'move';
        e.originalEvent.dataTransfer.setData('text/html', this.innerHTML);
    }

    function handleDragOver(e) {
        if (e.preventDefault) {
            e.preventDefault(); // Necessary. Allows us to drop.
        }

        if (e.originalEvent.dataTransfer) {
            e.originalEvent.dataTransfer.dropEffect = 'move';  // See the section on the DataTransfer object.
        }

        this.classList.add('over');
        return false;
    }

    function handleDragEnter(e) {
        // this / e.target is the current hover target.
        this.classList.add('over');
    }

    function handleDragLeave(e) {
        this.classList.remove('over');  // this / e.target is previous target element.
    }

    function handleDrop(e) {
        // this/e.target is current target element.

        if (e.stopPropagation) {
            e.stopPropagation(); // Stops some browsers from redirecting.
        }

        // Don't do anything if dropping the same column we're dragging.
        if (dragSrcEl != this) {
            // Set the source column's HTML to the HTML of the column we dropped on.
            dragSrcEl.innerHTML = this.innerHTML;
            this.innerHTML = e.originalEvent.dataTransfer.getData('text/html');
        }


        $('.drag-info').hide();
        $('.save-order').show();
        this.classList.remove('over');

        return false;
    }

    function handleDragEnd(e) {
        // this/e.target is the source node.

        [].forEach.call(cols, function (col) {
            col.classList.remove('over');
        });
    }

    // --------------------- Drag-n-drop End ------------------------------

    $('.multipleImageUploadInput').change(function () {
        $("#imageUploaderModal").modal('hide');
        $('.loader').show();
        var form = $(this).closest(".imageUploadForm");
        var type = $(form).find("input[name='type']").val();

        $(form).ajaxForm({
            success: function (res) {
                if (res.returnCode == 101) {

                    for (var i in res.result.imagePaths) {
                        var imagePath = res.result.imagePaths[i].tc_cover;
                        var imageObject = res.result.imagePaths[i].tc_id;
                        $("#imagesStack").append(imageBoxInStackTemplate.replace("__url__", imagePath).replace(/__id__/g, imageObject));
                    }
                    $("#imageUploaderModal").modal('hide');
                } else {
                    showDangerAlert(res.msg);
                }
                $('.loader').hide();
            }
        }).submit();
    });
    $(".ajaxForm").ajaxForm({
        beforeSubmit: function () {
        },
        success: function (res, status, xhr, $form) {
            if (res.returnCode == 101) {
                showSuccessAlert(res.msg);

                if (res.result && res.result.redirectTo) {
                    window.location.href = res.result.redirectTo;
                }
            }
            else {
                showDangerAlert(res.msg);
            }
        }
    });

    $('.ajaxForm').areYouSure(
        {
            message: 'It looks like you have been editing something. '
            + 'If you leave before saving, your changes will be lost.'
        }
    );

});

function showDangerAlert(content) {
    $.bigBox({
        title: "Alert",
        content: content,
        color: "#C46A69",
        icon: "fa fa-warning shake animated",
        timeout: 5000
    });
}

function showSuccessAlert(content) {
    $.bigBox({
        title: "Message",
        content: content,
        color: "#739E73",
        timeout: 5000,
        icon: "fa fa-check"
    });
}

function showMessageAlert(content) {
    $.bigBox({
        title: "Message",
        content: content,
        color: "#C79121",
        icon: "fa fa-shield fadeInLeft animated",
        number: "3",
        timeout: 5000
    });
}
function removeAccommodation(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to remove this accommodation?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/remove-accommodation/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}

function removeGuide(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to remove this guide?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/remove-guide/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}

function removeTrail(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to remove this trail?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/remove-trail/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}

function approveGuideReview(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to approve this review?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/approve-guide-review/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}
function rejectGuideReview(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to reject this review?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/reject-guide-review/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}
function removeGuideReview(id) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to remove this review?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            $.post("/admin-action/remove-guide-review/" + id, function (res) {
                if (res.returnCode == 101) {
                    if (res.result && res.result.redirectTo) {
                        window.location.href = res.result.redirectTo;
                    }
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}
function removeTrailReview(id) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to remove this review?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            $.post("/admin-action/remove-trail-review/" + id, function (res) {
                if (res.returnCode == 101) {
                    if (res.result && res.result.redirectTo) {
                        window.location.href = res.result.redirectTo;
                    }
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}
function approveTrailReview(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to approve this review?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/approve-trail-review/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}
function rejectTrailReview(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to reject this review?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/reject-trail-review/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}


function openEditImage(el) {
    var editModalEl = $('#editImageModal');
    var imgEl = editModalEl.find('img');
    editModalEl.modal('show');
    imgEl.attr('src', $(el).attr('src'));
    imgEl.attr('data-id', $(el).data('id'));
    editModalEl.find('input[name=is_featured]').attr('checked', $(el).data('is_featured') == 'on' ? true : false);
    editModalEl.find('input[name=image_id]').val($(el).data('id'));


}

function saveImageOrder() {
    var order_array = [];
    $('.draggable .imageBox').each(function () {
        var image_id = $(this).find('img').data('id');
        var image_order = $(this).data('number');
        order_array[image_order] = image_id;
    });

    $.post("/admin-action/save-image-order", {data: JSON.stringify(order_array)}, function (res) {
        if (res.returnCode == 101) {
            showSuccessAlert(res.msg);
        }
    }, "json");


}
function removeImage(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure to remove the image?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).closest("form").find("input[name='image_id']").val();
            $.post("/admin-action/remove-image/" + id, function (res) {

                if (res.returnCode == 101) {
                    $('#editImageModal').modal('hide');
                    $('div[data-id="'+this.toString()+'"]').remove();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }.bind(id), "json");
        }
    });
    return false;
}
function uncheck(el) {
    if ($(el).is(':checked')) {
        $(el).val('on');
        if ($(el).data('type') == 'slide') {
            $('.url-section').removeClass('hidden');
        }
    }
    else {
        $(el).val('off');
        if ($(el).data('type') == 'slide') {
            $('.url-section').addClass('hidden');
        }
    }
}
function removeUser(el) {
    $.SmartMessageBox({
        title: "Attention!",
        content: "Are you sure you want to remove this user?",
        buttons: '[Cancel][OK]'
    }, function (ButtonPressed) {
        if (ButtonPressed === "OK") {
            var id = $(el).data('id');
            $.post("/admin-action/remove-user/" + id, function (res) {
                if (res.returnCode == 101) {
                    window.location.reload();
                    showSuccessAlert(res.msg);
                } else {
                    showDangerAlert(res.msg);
                }
            }, "json");
        }
    });
    return false;
}


var imageBoxInStackTemplate = "" +
    "<div class='imageBox smart-form photo-grid' data-id='__id__'>" +
    "<img src='__url__' onclick='openEditImage(this)' data-id='__id__'>" +
    "<div class='edit_button'>" +
    '<button class="btn-primary btn-xs edit-image" type="button" onclick="openEditImage($(this).parent().siblings(\'' + 'img' + '\'))">' + "Edit" + "</button>" +
    "</div>";