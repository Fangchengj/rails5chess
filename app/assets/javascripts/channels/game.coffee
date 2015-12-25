App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    @printMessage("Waiting for opponent...")
    @install()

  received: (data) ->
    switch data.action
      when "game_start"
        App.board.position("start")
        App.board.orientation(data.msg)
        @printMessage("Game started! You play as #{data.msg}.")
      when "make_move"
        [source, target] = data.msg.split("-")

        App.board.move(data.msg)
        App.game.move
          from: source
          to: target
          promotion: "q"
      when "opponent_forfeits"
        @printMessage("Opponent forfeits. You win!")

  install: ->
    $(document).on "made_move", (event, move) =>
      @perform("make_move", move)

  printMessage: (message) ->
    $("#messages").append("<p>#{message}</p>")
