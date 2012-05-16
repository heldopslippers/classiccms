
dropdown= ->
  $j('.dropdown1').live 'click', ->
    if $j(this).find('.dropdown1_mid').hasClass('active')
      $j(this).find('.dropdown1_mid').removeClass('active')
      $j(this).find('.dropdown1_mid').animate {height: '0px', overflow: 'scroll' }, 500
      $j(this).find('.hack').animate { height: '100px'}, 500
    else
      $j(this).find('.dropdown1_mid').animate {height: '100px'}, 500
      $j(this).find('.dropdown1_mid').addClass('active')
      $j(this).find('.hack').animate {height: '10px'}, 500


# FOR IMAGES! -->
image_popup = ->
  #$j('#iki #edit_box .image_select').live 'click', ->
  $j.get '/cms/image_window', (data) ->
    $j('body').prepend data
    $j('#iki .background, #iki #logo').fadeIn 400
    $j('#iki #edit_box').animate { marginTop: '0px' }, 500
    upload_file()
add_directory= ->
  $j('#iki.image_window .add').live 'click', ->
    $j.post '/cms/add_directory', {name: $j(this).siblings('input[name=name]').val(), parent: $j(this).siblings('input[name=parent]').val()}, (data) ->
      $j('#iki.image_window').replaceWith data
select_directory= ->
  $j('#iki.image_window ul li.map_big a').live 'click', ->
    ul = $j(this).closest('li').children('ul')
    id = $j(this).closest('li').attr('id')
    $j('#iki.image_window ul li a').removeClass('active')
    $j(this).addClass('active')
    $j(ul).slideToggle()
    $j('.files').fadeOut()
    load_images(id)
    #$j(".files.#{id}").fadeIn()
    $j('#file_upload').show()
    $j('#file_upload').uploadifySettings('postData', {id: id})
single_file_select= ->
  $j('#iki.image_window img.images').live 'click', ->
    if $j(this).hasClass('selected')
      $j('#iki.image_window img.images').removeClass 'selected'
    else
      $j('#iki.image_window img.images').removeClass 'selected'
      $j(this).addClass 'selected'

multiple_file_select= ->
  $j('#iki.image_window img.images').live 'click', ->
    if $j(this).hasClass 'selected'
      $j('#iki.image_window images_wrapper input[value=]')
    $j(this).toggleClass 'selected'
    $j.each $('#iki.image_window images_wrapper input[type=hidden]'), (object) ->
      alert object.attr('value')

load_images= (parent)->
  $j.get "/cms/images/#{parent}", (data) ->
    $j('.images_wrapper .files').replaceWith data
    $j('.images_wrapper .files').fadeIn()
    #$j('#iki.image_window img.images').addClass 'selected'

upload_file= ->
  $j('#file_upload').uploadify({
      'swf'         : '/cms/uploadify.swf'
      'uploader'    : '/cms/add_file'
      'cancelImage' : '/cms/images/cancel.png'
      'multi'       : true
      'auto'        : true
      'postData'    : {id : 'none'}
      'onQueueComplete' : ->
        load_images($j('#iki.image_window ul li a.active').first().closest('li').attr('id'))
  })
