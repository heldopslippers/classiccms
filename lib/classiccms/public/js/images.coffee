$ ->
  new Image

class Image
  constructor: ->
    @p =
      images:   '.images'
      image:    '.images .image img'
      destroy:  '.images .image .destroy'
      button:   '#file_upload'
    @listen()

  listen: ->
    $('#edit_bg').slideDown()
    @set_upload_button()
    @select()
    @destroy()

  select: () ->
    $('img').click ->
      input = $('input').first().val()
      url = $(this).attr('url')
      window.opener.CKEDITOR.tools.callFunction(input, url)
      self.close()

  destroy: () ->
    $(@p.images + ' .image').live 'mouseover mouseout', (event) =>
      if (event.type == 'mouseover')
        $(event.currentTarget).find('.destroy').show()
      else
        $(event.currentTarget).find('.destroy').hide()
    $(@p.destroy).click (event) =>
      id = $(event.currentTarget).parent().attr('id')
      $('.images').find('#' + id).hide()
      $.post '/cms/image/destroy', {id: id}

  set_upload_button: ->
    if($('#file_upload').length != 0)
      $('#file_upload').uploadify
        'swf'      : '/cms/js/uploadify/uploadify.swf'
        'uploader' : '/cms/upload/image'
        'onUploadSuccess' : (file, data, response) =>
          $(data).replaceAll(@p.images)
          @select()
          @destroy()

