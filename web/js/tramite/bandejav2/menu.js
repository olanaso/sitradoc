/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(function () {

    $(".sidebar-menu li").each(function (index) {
        $(this).hide();
    });

    $(".sidebar-menu li ul li").each(function (index) {
        $(this).hide();
    });

    var n = Usuario.roles.toUpperCase().search("SECRETARIO");

    if (n === -1) {

        if (!Usuario.bindjefe) {

            //usuario comun
            $('.usuario').show()

        } else {
            //jefe

            $('.jefe').show()

        }


    } else {
        $('.secretario').show()
        //secretario
    }

    //


    $('.modal').on('show.bs.modal', function (e) {

        $('body').children().addClass('blurcontent')
        $('.modal').removeClass('blurcontent');

    })

    $('.modal').on('hide.bs.modal', function (e) {
        $('body').children().removeClass('blurcontent');
        
    })

});
