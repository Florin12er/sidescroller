extends CanvasLayer

func _ready() -> void:
	GameManger.gained_coins.connect(update_coin_display)

func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManger.coins)
