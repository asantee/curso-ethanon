#include "Menu.angelscript"

void main()
{
	loadMenu();
}

void loadGame()
{
	LoadScene("scenes/space.esc", "startGame", "updateGame");
}

uint asteroidInterval = 400;
uint elapsedTime = 0;

void updateGame()
{
	elapsedTime += GetLastFrameElapsedTime();

	// se passaram-se 'asteroidInterval' milisegundos,
	// adiciona um novo asteroide à cena e volta o timer
	if (elapsedTime  > asteroidInterval && !gameOver)
	{
		AddEntity("asteroid.ent", vector3(randF(GetScreenSize().x), -64.0f, 0.0f));
		elapsedTime -= asteroidInterval;
	}

	// exibe mensagem "game over"
	if (gameOver)
	{
		vector2 spritePos = GetScreenSize() * 0.5f;

		// centraliza a origem do sprite
		SetSpriteOrigin("sprites/game-over.png", vector2(0.5f, 0.5f));

		// desenha sprite
		DrawSprite("sprites/game-over.png", spritePos);

		// volta ao menu se o jogador clicar na tela ou pressionar esc
		ETHInput@ input = GetInputHandle();
		if (input.GetLeftClickState() == KS_HIT
			|| input.GetKeyState(K_ESC) == KS_HIT)
		{
			loadMenu();
		}
	}
}

bool gameOver;

void startGame()
{
	// assegura que o timer será zerado no início da cena
	elapsedTime = 0;

	// assegura de que 'gameOver' será sempre false ao iniciar
	gameOver = false;

	LoadSoundEffect("soundfx/shoot.mp3");
	LoadSoundEffect("soundfx/asteroid_explosion.mp3");
	LoadSoundEffect("soundfx/explosion.ogg");
}

void ETHCallback_asteroid(ETHEntity@ asteroid)
{
	// move o asteroide para baixo
	asteroid.AddToPositionY(UnitsPerSecond(100.0f));

	// se o asteroide ja saiu por inteiro da tela...
	if (asteroid.GetPositionY() > GetScreenSize().y + 64.0f)
	{
		asteroid.SetPositionY(-64.0f);
		asteroid.SetPositionX(randF(GetScreenSize().x));
	}

	// Copia para 'entities' uma referência para
	// cada entidade ao redor de 'asteroid'
	ETHEntityArray entities;
	GetEntitiesAroundEntity(asteroid, entities);

	// define o raio do círculo imaginário do asteroide
	float asteroidRadius = 30.0f;

	// passa por todas as entidades no array 'entities'
	for (uint i = 0; i < entities.size(); i++)
	{
		// se essa entidade for um míssil
		if (entities[i].GetEntityName() == "missile.ent")
		{
			// define o raio do círculo imaginário do missil
			float missileRadius = 8.0f;

			// se a distância entre as entidades for maior que seu raio
			float dist = distance(asteroid.GetPositionXY(), entities[i].GetPositionXY());
			if (dist < missileRadius + asteroidRadius)
			{
				// destroi o míssil
				AddEntity("explosion.ent", entities[i].GetPosition());
				DeleteEntity(entities[i]);

				// decrementa a resistência do asteroide
				asteroid.AddToInt("resistance", -1);
			}
		}
		else if (entities[i].GetEntityName() == "spaceship.ent")
		{
			// define o raio do círculo imaginário da nave
			float spaceshipRadius = 20.0f;

			// se a distância entre as entidades for maior que seu raio
			float dist = distance(asteroid.GetPositionXY(), entities[i].GetPositionXY());
			if (dist < spaceshipRadius + asteroidRadius)
			{
				// destroi a nave
				AddEntity("explosion.ent", entities[i].GetPosition());
				DeleteEntity(entities[i]);
				PlaySample("soundfx/explosion.ogg");
				gameOver = true;
			}
		}
	}

	// destroi o asteroide se a resistencia acabar
	if (asteroid.GetInt("resistance") <= 0)
	{
		AddEntity("asteroid_explosion.ent", asteroid.GetPosition());
		DeleteEntity(asteroid);
		PlaySample("soundfx/asteroid_explosion.mp3");
	}
}

void ETHCallback_missile(ETHEntity@ thisEntity)
{
	thisEntity.AddToPositionY(UnitsPerSecond(-350.0f));
	if (thisEntity.GetPositionY() < -64.0f)
	{
		DeleteEntity(thisEntity);
	}
}

void ETHCallback_spaceship(ETHEntity@ thisEntity)
{
	ETHInput@ input = GetInputHandle();

	vector2 direction(0,0);
	float speed = UnitsPerSecond(250.0f);

	if (input.KeyDown(K_RIGHT))
		direction += vector2(1.0f, 0.0f);
	if (input.KeyDown(K_LEFT))
		direction += vector2(-1.0f, 0.0f);
	if (input.KeyDown(K_UP))
		direction += vector2(0.0f,-1.0f);
	if (input.KeyDown(K_DOWN))
		direction += vector2(0.0f, 1.0f);

	thisEntity.AddToPositionXY(normalize(direction) * speed);
	limitPositionToScreen(thisEntity);

	if (input.GetKeyState(K_SPACE) == KS_HIT)
	{
		AddEntity("missile.ent", thisEntity.GetPosition());
		PlaySample("soundfx/shoot.mp3");
	}
}

// Limita o movimento da entidade à área da tela
void limitPositionToScreen(ETHEntity@ entity)
{
	vector2 screenSize = GetScreenSize();
	vector2 pos = entity.GetPositionXY();

	if (pos.x < 0.0f)
		entity.SetPositionX(0.0f);
	if (pos.y < 0.0f)
		entity.SetPositionY(0.0f);

	if (pos.x > screenSize.x)
		entity.SetPositionX(screenSize.x);
	if (pos.y > screenSize.y)
		entity.SetPositionY(screenSize.y);
}
