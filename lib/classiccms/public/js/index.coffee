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
      image_button:  '#iki .image_select'

    @listen()
    @show()

  listen: ->
    $j(@p.cancel).click => @hide()
    $j(@p.create).click => @create('/cms/save')
    $j(@p.destroy).click (event) => @destroy('/cms/destroy', $(event.target).attr('id'))
    $j(@p.image_button).click => new Popup
    if($j('#file_upload').length != 0)
      $j('#file_upload').uploadify(
        'swf'      : '/cms/js/uploadify/uploadify.swf'
        'uploader' : '/cms/upload/image'
        )
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
        filebrowserBrowseUrl : '/cms/browse',
        filebrowserUploadUrl : '/cms/uploader/upload',
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
class Popup
  constructor: ->
    @p =
      base:          '#iki'
      logo:          '#iki #logo'
      background:    '#iki .background'
      edit_box:      '#iki #edit_box'
    @load('/cms/image_window')

  load: (url) ->
    $j.get '/cms/image_window', (data) =>
      $j('body').prepend data
      @show()
      new Directory

  show: ->
    $j(@p.logo).fadeIn 400
    $j(@p.background).fadeIn 400
    $j(@p.edit_box).animate { marginTop: '0px' }, 500

  hide: ->
    $j(@p.logo).fadeOut 400
    $j(@p.background).fadeOut 400
    $j(@p.edit_box).animate { marginTop: '-640px' }, 500, =>
class Directory
  constructor: ->
    @p =
      base: '#iki.image_window'
      directories: '#iki.image_window ul li.map_big a'
      add: '#iki.image_window .add'

    @images = new Image
    @listen()

  listen: ->
    $j(@p.directories).click (event) => @select(event.target)
    $j(@p.add).click (event) => @add(event.target)

  select: (item) ->
    ul = $j(item).closest('li').children('ul')
    id = $j(item).closest('li').attr('id')
    $j(@p.directories).removeClass('active')
    $j(item).addClass('active')
    $j(ul).slideToggle()
    @images.load(id)

  add: (item) ->
    $j.post '/cms/add_directory', {
      name: $j(item).siblings('input[name=name]').val(),
      parent: $j(item).siblings('input[name=parent]').val() }, (data) =>
        $j(@p.base).replaceWith data
        new Directory
class Image
  constructor: ->
    @p =
      images: '.images_wrapper .files'
      image: '#iki.image_window img.images'
      directory_active: '#iki.image_window ul li a.active'
      button: '#file_upload'
    if @setup_upload()
      @show_button 'none'
    @listen()

  listen: ->
    $j(@p.image).live 'click', (item) => @single_select item.target

  setup_upload: ->
    config = {
      'swf'         : '/cms/uploadify.swf'
      'uploader'    : '/cms/add_file'
      'cancelImage' : '/cms/images/cancel.png'
      'multi'       : true
      'auto'        : true
      'postData'    : {id: 'none'}
      'onQueueComplete' : (stats) => @load($j(@p).first().closest('li').attr('id'))
    }
    $j(@p.button).uploadify config

  load: (directory) ->
    @show_button directory

    $j(@p.images).fadeOut()
    $j.get "/cms/images/#{directory}", (data) =>
      $j(@p.images).replaceWith data
      $j(@p.images).fadeIn()

  show_button: (directory) ->
    $j(@p.button).show()
    $j(@p.button).uploadifySettings 'postData', {id: directory}

  single_select: (target) ->
    if $j(target).hasClass 'selected'
      $j(@p.image).removeClass 'selected'
    else
      $j(@p.image).removeClass 'selected'
      $j(target).addClass 'selected'
  multiple_select: (target) ->
    if $j(target).hasClass 'selected'
      $j('#iki.image_window images_wrapper input[value=]')
    $j(target).toggleClass 'selected'
    $j.each $('#iki.image_window images_wrapper input[type=hidden]'), (object) ->
      alert object.attr('value')

$j ->
  new Cms
