{CompositeDisposable} = require 'atom'

module.exports = UniqLine =
  subscriptions: null

  activate: ->
    atom.commands.add 'atom-text-editor',
    'uniq-line:uniq': ->
      editor = atom.workspace.getActiveTextEditor()
      uniqLine(editor)

uniqLine = (editor) ->
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
