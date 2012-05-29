class Cms
  constructor: ->
    @input = 'input[name=cms]'
    sort = new Sort

    this.listen('/cms/add', '.iki_IconMake')
    this.listen('/cms/edit', '.iki_IconEdit')

  listen: (url, button) ->
    $j(button).live 'click', (event) =>
      this.load url, $j(event.target).find(@input).val()
  load: (url, cms) ->
    $j.post url, {cms: cms}, (data) =>
      $j('body').prepend data
      panel = new TopPanel

class Sort
  constructor: ->
    $j('[sortable]').sortable {
      containment: 'parent'
      items: "> [sort][sort!='']"
      tolerance: 'pointer'
      start: (event, ui) ->
        $j(ui.item).find('.iki_IconEdit').hide()
        $j(ui.helper).find('.iki_IconEdit').hide()
      stop: (event, ui) ->
        $j(ui.item).find('.iki_IconEdit').show()
      update: (event,ui) ->
        section = $j(this).attr('sortable')
        order = []
        $j(this).find('[sort]').each (index, item)->
          order[index] = $j(item).attr('sort')
        $j.post '/cms/sort', {section: section, order: order}
    }

class Image
  constructor: (input) ->
    @input = input
    @p =
      images:   '#iki #edit_bg .images'
      image:    '#iki #edit_bg .images .image img'
      destroy:  '#iki #edit_bg .images .image .destroy'
      button:   '#iki #edit_bg #file_upload'
    @listen()

  listen: ->
    $j('#edit_bg').slideUp()
    $j.get '/cms/images', (data) =>
      @form = $j('#edit_bg')
      $j('#edit_bg').after(data)
      @set_upload_button()
      $j('#' + @input.val()).addClass('selected')
      @select()
      @destroy()

  destroy: () ->
    $j(@p.images + ' .image').live 'mouseover mouseout', (event) =>
      if (event.type == 'mouseover')
        $j(event.currentTarget).find('.destroy').show()
      else
        $j(event.currentTarget).find('.destroy').hide()
    $j(@p.destroy).click (event) =>
      id = $j(event.currentTarget).parent().attr('id')
      $j('.images').find('#' + id).hide()
      $j.post '/cms/image/destroy', {id: id}

  select: () ->
    $j(@p.image).click (event) =>
      $j(@p.image).parent().removeClass('selected')
      $j(event.currentTarget).parent().addClass('selected')
      $j(@input).val($j(event.currentTarget).parent().attr('id'))
      $j('#edit_bg.popup').slideUp()
      @form.slideDown()

  set_upload_button: ->
    if($j('#file_upload').length != 0)
      $j('#file_upload').uploadify
        'swf'      : '/cms/js/uploadify/uploadify.swf'
        'uploader' : '/cms/upload/image'
        'onUploadSuccess' : (file, data, response) =>
          $j(data).replaceAll(@p.images)
          @select()
          @destroy()


class TopPanel
  constructor: ->
    @editors = new Editor
    @p =
      base:          '#iki'
      logo:          '#iki #logo'
      background:    '#iki .background'
      edit_box:      '#iki #edit_box'
      form:          '#iki #edit_box form'
      cancel:        '#iki .cancel'
      create:        '#iki #edit_box .save'
      destroy:       '#iki #edit_box #edit_bottom_nav .delete'
      destroy_label: '#iki .delete_item'
      image_select:  '#iki .image_select'

    @listen()
    @show()

  listen: ->
    $j(@p.cancel).click => @hide()
    $j(@p.create).click => @create('/cms/save')
    $j(@p.destroy).click (event) => @destroy('/cms/destroy', $j(event.target).attr('id'))
    $j(@p.image_select).click => new Image($j(event.target).next())
    @delete_button_hover()

  create: (url) ->
    $j.post url, $j(@p.form).serialize(), (data) =>
      if data == ''
        window.location.reload()
      else
        $j.each data, (index, value)=>
          $j(@p.form).find("label[key=#{index}] p").text(value[0])

  destroy: (url, id) ->
    $j.post url, {id: id}, ->
      window.location.reload()

  show: ->
    $j(@p.logo).fadeIn 400
    $j(@p.background).fadeIn 400
    $j(@p.edit_box).animate { marginTop: '0px' }, 500
    @editors.add()

  hide: ->
    $j(@p.logo).fadeOut 400
    $j(@p.background).fadeOut 400
    $j(@p.edit_box).animate { marginTop: '-640px' }, 500, =>
      @editors.remove()
      $j(@p.base).remove()

  delete_button_hover: ->
    combi = "#{@p.destroy}, #{@p.destroy_label}"
    $j(combi).mouseenter =>
      $j(combi).stop()
      $j(combi).addClass 'active'
      $j(@p.destroy_label).animate {
        marginLeft: '-16px'
        backgroundPosition: '0px'
        width: '86px'
        fontSize: '10px'
      }, 500
    $j(combi).mouseleave =>
      $j(combi).stop()
      $j(combi).removeClass 'active'
      $j(@p.destroy_label).animate {
        marginLeft: '-45px'
        backgroundPosition: '-60px'
        width: '86px'
        fontSize: '0px'
      }, 500

class Editor
  constructor: ->
    @p =
      textarea: '#edit_box textarea'
      buttons: '#iki .cke_button a'
      config: {
        skin : 'kama',
        toolbarCanCollapse : false,
        toolbar : [
          { name: 'document', items : [ 'Source','-']},
          { name: 'basicstyles', items : [ 'Bold','Underline','Italic','-'] },
          { name: 'paragraph',   items : ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-', 'NumberedList','BulletedList','-' ] },
          { name: 'insert', items : [ 'Image','HorizontalRule','SpecialChar','-']},
          { name: 'clipboard', items : ['PasteFromWord','-','Undo','Redo','-' ]},
          { name: 'links', items : [ 'Link','Unlink','-'] },
          { name: 'tools', items : [ 'Maximize' ] }
        ],
        filebrowserBrowseUrl : '/cms/ckeditor/images',
        filebrowserWindowWidth : '640',
        filebrowserWindowHeight : '480'
      }
  hover: ->
    $j(@p.buttons).mouseenter ->
      title = $j(this).attr('title')
      $j(this).closest('.wrapper').find('label p').text "(#{title})"
      $j(this).attr('title', '')
    $j(@p.buttons).mouseleave ->
      title = $j(this).closest('.wrapper').find('label p').text()
      title = title.replace(')', '').replace('(', '')
      $j(this).closest('.wrapper').find('label p').text('')
      $j(this).attr('title', title)
  add: ->
    $j(@p.textarea).each (index, element) =>
      $j(element).ckeditor(@p.config)
    @hover()
  remove: ->
    if $j(@p.textarea).length != 0
      $j(@p.textarea).ckeditorGet().destroy()


$j ->
  new Cms
