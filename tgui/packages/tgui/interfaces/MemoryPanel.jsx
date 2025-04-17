import { Button, Dimmer, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const STORY_VALUE_KEY = -1;
const STORY_VALUE_SHIT = 0;
const STORY_VALUE_NONE = 1;
const STORY_VALUE_MEH = 2;
const STORY_VALUE_OKAY = 3;
const STORY_VALUE_AMAZING = 4;
const STORY_VALUE_LEGENDARY = 5;

const MemoryQuality = (props) => {
  const { act } = useBackend();
  const { quality } = props;

  if (quality === STORY_VALUE_KEY) {
    return (
      <Button
        icon="key"
        color="transparent"
        tooltipPosition="right"
        tooltip={`
          Это ключевое воспоминание. В нем содержится важная информация.
          которую вы, возможно, захотите перепроверить в будущем.
        `}
      />
    );
  }
  if (quality === STORY_VALUE_SHIT) {
    return (
      <Button
        icon="poop"
        color="transparent"
        tooltipPosition="right"
        tooltip={`
          Это воспоминание совсем не интересно! Из него не получится
          искусства и вряд ли перейдет к будущим поколениям.
        `}
      />
    );
  }
  if (quality === STORY_VALUE_NONE) {
    return (
      <Button
        icon="star"
        color="transparent"
        tooltipPosition="right"
        tooltip={`
          Это воспоминание довольно безвкусное. Из него получится довольно
          посредственного искусства и вряд ли перейдет к будущим поколениям.
  `}
      />
    );
  }
  if (quality === STORY_VALUE_MEH) {
    return (
      <Button
        icon="star"
        style={{
          background:
            'linear-gradient(to right, #964B30, #D68B60, #B66B30, #D68B60, #964B30);',
        }}
        tooltipPosition="right"
        tooltip={`
          Это воспоминание не слишком интересно. Из него может получиться
          неплохой рассказ, но не стоит на это рассчитывать.
    `}
      />
    );
  }
  if (quality === STORY_VALUE_OKAY) {
    return (
      <Button
        icon="star"
        style={{
          background:
            'linear-gradient(to right, #636363, #a3a3a3, #6e6e6e, #a3a3a3, #636363);',
        }}
        tooltipPosition="right"
        tooltip={`
          Это воспоминание очень хорошее! Можно рассказать несколько хороших историй
          и, возможно, даже вернутся к будущим поколениям.
      `}
      />
    );
  }
  if (quality === STORY_VALUE_AMAZING) {
    return (
      <Button
        icon="star"
        style={{
          background:
            'linear-gradient(to right, #AA771C, #BCB68A, #B38728, #BCB68A, #AA771C);',
        }}
        tooltipPosition="right"
        tooltip={`
          Это замечательное воспоминание! Вы могли бы рассказать о нем отличную историю,
          и она бы с успехом передалась будущим поколениям!
      `}
      />
    );
  }
  if (quality === STORY_VALUE_LEGENDARY) {
    return (
      <Button
        icon="crown"
        style={{
          background:
            'linear-gradient(to right, #56A5B3, #75D4E2, #56A5B3, #75D4E2, #56A5B3)',
        }}
        tooltipPosition="right"
        tooltip={`
          Об этих воспоминаниях слагают легенды! Из нее можно сделать
          легендарного искусства и, вероятно, перейдет к будущим поколениям.
        `}
      />
    );
  }
  // Default return / error
  return (
    <Button
      icon="question"
      tooltipPosition="right"
      tooltip={`
        У этой памяти нет достоверного качества. Мы понятия не имеем, насколько хорошим
        или плохой она может быть. Это ошибка, и о ней следует сообщить!
      `}
    />
  );
};

export const MemoryPanel = (props) => {
  const { act, data } = useBackend();
  const memories = data.memories || [];
  return (
    <Window title="Панель памяти" width={400} height={500}>
      <Window.Content>
        <Section
          maxHeight="32px"
          title="Воспоминания"
          buttons={
            <Button
              color="transparent"
              tooltip={`
                Это ваши воспоминания. Вы получаете их, совершая значимые поступки.
                и вы можете использовать их в искусстве!
              `}
              tooltipPosition="bottom-start"
              icon="info"
            />
          }
        />
        {(!memories && (
          <Dimmer fontSize="28px" align="center">
            You have no memories!
          </Dimmer>
        )) || (
          <Stack vertical>
            {memories.map((memory) => (
              <Stack.Item key={memory.name}>
                <Section>
                  <MemoryQuality quality={memory.quality} /> {memory.name}
                </Section>
              </Stack.Item>
            ))}
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
