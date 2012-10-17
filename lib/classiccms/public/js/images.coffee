
$ ->
  new Browser

class Browser
  constructor: ->
    @input = $('#input').first().val()
    @type = $('#type').first().val()

    @p =
      images:   '.images'
      image:    'img'
      destroy:  '.destroy'
      button:   '#file_upload'
    @listen()
  listen: ->
    $('#edit_bg').slideDown()
    @set_upload_button()
    @select()
    @destroy()
    @add_tooltip()
    $('ul.menu li').click (event) =>  @change_window($(event.currentTarget).attr('id'))

  add_tooltip: ->
    $('[rel=tooltip]').tooltip();

  change_window: (id)->
    console.log id
    $('.menu li').removeClass('active')
    $('#' + id).addClass('active')
    if id == 'images'
      $('.files').hide()
    else
      $('.images').hide()
    $('.'+id).show()

  select: () ->
    $('.item').click (event)=>
      url = $(event.currentTarget).attr('url')
      ckeditor = $('input[name=return]').first().val()
      if ckeditor.length > 0
        window.opener.CKEDITOR.tools.callFunction(ckeditor, url)
      else if @type == 'document'
        window.opener.$j('#' + @input).first().val($(event.currentTarget).attr('id'))
        window.opener.$j('#' + @input + '_preview').empty().append($(event.currentTarget).attr('name'))
      else
        window.opener.$j('#' + @input).first().val($(event.currentTarget).attr('id'))
        window.opener.$j('#' + @input + '_preview img').attr('src', $(event.currentTarget).attr('src'))
      self.close()

  destroy: () ->
    $(@p.destroy).click (event) =>
      id = $(event.currentTarget).attr('data-id')
      $('#' + id).hide()
      $.post '/cms/file/destroy', {id: id}

  set_upload_button: ->
    if($('#file_upload').length != 0)
      $('#file_upload').uploadify
        'buttonClass' : 'btn btn-info'
        'buttonText'  : 'upload bestanden'
        'swf'      : '/cms/js/uploadify/uploadify.swf'
        'uploader' : '/cms/upload'
        'queueID'  : 'file_queue'
        'onSelect' : (file) =>
          console.log(file)
          $('#progress').append("<div class='alert alert-info' id='file-#{file.index}'><strong>"+ file.name + "</strong><button class='close' type='button' date-dismiss='alert'>x</button></div>")
        'onUploadComplete' : (file) =>
          $("#progress #file-#{file.index}").hide();
        'onUploadSuccess' : (file, data, response) =>
          $('.wrapper').empty().append(data)
          #$(data).replaceAll('.wrapper')
          @select()
          @destroy()
          @add_tooltip()
          @change_window($('ul.menu li.active').first().attr('id'))

