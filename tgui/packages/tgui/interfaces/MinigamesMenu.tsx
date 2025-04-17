import { Button, Divider, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const MinigamesMenu = (props) => {
  const { act } = useBackend();

  return (
    <Window title="Меню мини-игр" width={530} height={320}>
      <Window.Content>
        <Section title="Выберите мини-игру" textAlign="center" fill>
          <Stack>
            <Stack.Item grow>
              <Button
                content="CTF"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('ctf')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                content="Мафия"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('mafia')}
              />
            </Stack.Item>
          </Stack>
          <Divider />
          <Stack>
            <Stack.Item grow>
              <Button
                content="Баскетбол"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('basketball')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                content="Бой насмерть"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('deathmatch')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
