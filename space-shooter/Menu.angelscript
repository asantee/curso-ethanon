// Menu.angelscript:
#include "Button.angelscript"

void loadMenu()
{
	LoadScene("scenes/menu.esc", "startMenu", "updateMenu");
}

// referência global para o botão
Button@ startGameButton;

void startMenu()
{
	vector2 screenSize = GetScreenSize();

	// cria o botão
	@startGameButton = Button("sprites/start-game.png", screenSize * vector2(0.5f, 0.8f));

	// centraliza e posiciona corretamente a entidade de título
	SeekEntity("title.ent").SetPositionXY(screenSize * vector2(0.5f, 0.3f));
}

void updateMenu()
{
	// desenha e atualiza o botão
	startGameButton.putButton();

	// se o botão for pressionado, começa o jogo
	if (startGameButton.isPressed())
		loadGame();
}
