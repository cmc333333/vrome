class CmdBox
  box_id = "_vrome_cmd_box"
  input_box_id = "_vrome_cmd_input_box"

  cmdBoxTitle = (force_create=false) =>
    elems = $("#_vrome_cmd_box span")
    @cmdBox().append $("<span>") if force_create and elems.length == 0
    $("#_vrome_cmd_box span")

  cmdBoxInput = (force_create=false) =>
    elems = $("#_vrome_cmd_box input")
    @cmdBox().append $("<input>", id: input_box_id) if force_create and elems.length == 0
    $("#_vrome_cmd_box input")

  @isActive: ->
    document.activeElement and (document.activeElement.id is input_box_id)

  @cmdBox: ->
    $("body").prepend $("<div>", id: box_id) if $("##{box_id}").length == 0
    $("##{box_id}").attr "rand_id", Math.random().toString()

  @set: (o, force=true) =>
    if (typeof o.title is "string")
      cmdBoxTitle(force).unbind().text(o.title).mousedown o.mouseOverTitle
    if (typeof o.content is "string")
      input = cmdBoxInput(force)
      input.unbind().val(o.content).keydown(o.pressDown).keyup(o.pressUp).keypress(o.pressPress).focus()
    if (typeof o.selection is "string")
      [start, length] = [input.val().indexOf(o.selection), o.selection.length]
      input.prop(selectionStart: start, selectionEnd: start+length)
    setTimeout @remove, Number(o.timeout), @cmdBox().attr("rand_id") if o.timeout

  @softSet: (o) =>
    @set(o, false)

  @get: () ->
    input = cmdBoxInput()
    [value, start, end] = [input.val() || "", input.prop("selectionStart"), input.prop("selectionEnd")]
    no_selection_content = "#{value[0...start]}#{value[end..-1]}"
    title: cmdBoxTitle().text() or "", content: value, selection: value[start..end], _content: no_selection_content

  @remove: (rand_id=null) ->
    (if rand_id then $("##{box_id}").filter("[rand_id='#{rand_id}']") else $("##{box_id}")).unbind().remove()

  @blur: -> cmdBoxInput()?.blur()


root = exports ? window
root.CmdBox = CmdBox
