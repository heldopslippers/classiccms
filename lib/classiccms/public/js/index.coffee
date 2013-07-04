go = ()->
  console.log 'woohoo'
class Cms
  constructor: ->
    @input = 'input[name=cms]'
    sort = new Sort

    this.listen('/cms/add', '.iki_IconMake')
    this.listen('/cms/edit', '.iki_IconEdit')

  listen: (url, button) ->
    $j(button).on 'click', (event) =>
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
    window.open('/cms/ckeditor/files?input='+$(input).attr('id')+'&type=image','upload','width=960,height=750,left=200,top=100,screenX=200,screenY=100')

class Document 
  constructor: (input) ->
    window.open('/cms/ckeditor/files?input='+$(input).attr('id')+'&type=document','upload','width=960,height=750,left=200,top=100,screenX=200,screenY=100')


class TopPanel
  constructor: ->
    @editors = new Editor
    @p =
      base:          '#iki'
      logo:          '#iki #logo'
      background:    '#iki .background'
      edit_box:      '#iki #edit_box'
      menu:          '#iki #edit_box ul.menu li'
      form:          '#iki #edit_box form'
      cancel:        '#iki .cancel'
      create:        '#iki #edit_box .save'
      destroy:       '#iki #edit_box #edit_bottom_nav .delete'
      destroy_label: '#iki .delete_item'
      image_select:  '#iki .image_select'
      document_select:  '#iki .document_select'

    @listen()
    @show()

  listen: ->
    $j(@p.cancel).click => @hide()
    $j(@p.menu).click (event) => @menu_switch(event.target)
    $j(@p.create).click => @create('/cms/save')
    $j(@p.destroy).click (event) => @destroy('/cms/destroy', $j(event.target).attr('id'))
    $j(@p.image_select).click (event) => new Image($j(event.target).next())
    $j(@p.document_select).click (event) => new Document($j(event.target).next())
    @delete_button_hover()
  
  menu_switch: (object) ->
    id = $(object).attr('data-cms-id')
    $(@p.menu).removeClass('active')
    $(@p.form).hide()
    $(object).addClass('active')
    $(@p.form + '[data-cms-id=' + id + ']').show()


  create: (url) ->
    request = $j.ajax(url: url, type: 'POST', data: $j(@p.form + ':visible').serialize(), dataType: 'json')
    request.fail =>
      window.location.reload()
    request.done (data) =>
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
      textarea: '#iki textarea'
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
        filebrowserBrowseUrl : '/cms/ckeditor/files',
        filebrowserImageBrowseUrl : '/cms/ckeditor/files?Type=Images',
        filebrowserWindowWidth : '960',
        filebrowserWindowHeight : '750'
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
      console.log 'wooh woop'
      $j(element).ckeditor(@p.config)
    @hover()
  remove: ->
    if $j(@p.textarea).length != 0
      $j(@p.textarea).ckeditorGet().destroy()


$j ->
  new Cms
