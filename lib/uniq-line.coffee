UniqLineView = require './uniq-line-view'
{CompositeDisposable} = require 'atom'

module.exports = UniqLine =
  uniqLineView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @uniqLineView = new UniqLineView(state.uniqLineViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @uniqLineView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that uniqs this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'uniq-line:uniq': => @uniq()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @uniqLineView.destroy()

  serialize: ->
    uniqLineViewState: @uniqLineView.serialize()

  uniq: ->
    console.log 'UniqLine was uniqd!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()

      tmp_line = ""
      outputText = ""
      
      # remove the same above-described line
      for line in selectedText.split("\n")
        if tmp_line == line
          continue
        outputText += line + "\n"
        tmp_line = line
      
      # remove the last line break
      outputText = outputText[0..outputText.length-2]
      
      editor.insertText(outputText)
