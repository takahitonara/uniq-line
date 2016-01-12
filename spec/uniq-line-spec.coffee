describe "unique line", ->
  [activationPromise, editor, editorView] = []

  uniqueLines = (callback) ->
    atom.commands.dispatch editorView, "uniq-line:uniq"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)

      activationPromise = atom.packages.activatePackage('uniq-line')

  describe "when entire lines are selected", ->
    it "marges the selected lines to unique lines", ->
      editor.setText """
        aaa
        bbb
        bbb
        ccc
      """
      editor.setSelectedBufferRange([[1,0], [4,0]])

      uniqueLines ->
        expect(editor.getText()).toBe """
          aaa
          bbb
          ccc
        """

  describe "when entire lines are selected", ->
    it "marges the selected lines to unique lines, not sort", ->
      editor.setText """
        aaa
        bbb
        bbb
        ccc
        aaa
      """
      editor.setSelectedBufferRange([[1,0], [4,0]])

      uniqueLines ->
        expect(editor.getText()).toBe """
          aaa
          bbb
          ccc
          aaa
        """

  describe "when entire lines are selected", ->
    it "doesn't marges the selected lines if continue lines don't exist", ->
      editor.setText """
        aaa
        bbb
        ccc
        bbb
      """
      editor.setSelectedBufferRange([[1,0], [4,0]])

      uniqueLines ->
        expect(editor.getText()).toBe """
          aaa
          bbb
          ccc
          bbb
        """
