import {
  Box,
  Button,
  Chart,
  Flex,
  Icon,
  LabeledList,
  Tooltip,
} from 'tgui-core/components';

import { useBackend } from '../../backend';

export const RecipeLookup = (props) => {
  const { recipe, bookmarkedReactions } = props;
  const { act, data } = useBackend();
  if (!recipe) {
    return <Box>Реакция не выбрана!</Box>;
  }

  const getReaction = (id) => {
    return data.master_reaction_list.filter((reaction) => reaction.id === id);
  };

  const addBookmark = (bookmark) => {
    bookmarkedReactions.add(bookmark);
  };

  return (
    <LabeledList>
      <LabeledList.Item bold label="Рецепт">
        <Icon name="circle" mr={1} color={recipe.reagentCol} />
        {recipe.name}
        <Button
          icon="arrow-left"
          ml={3}
          disabled={recipe.subReactIndex === 1}
          onClick={() =>
            act('reduce_index', {
              id: recipe.name,
            })
          }
        />
        <Button
          icon="arrow-right"
          disabled={recipe.subReactIndex === recipe.subReactLen}
          onClick={() =>
            act('increment_index', {
              id: recipe.name,
            })
          }
        />
        {bookmarkedReactions && (
          <Button
            icon="book"
            color="green"
            disabled={bookmarkedReactions.has(getReaction(recipe.id)[0])}
            onClick={() => {
              addBookmark(getReaction(recipe.id)[0]);
              act('update_ui');
            }}
          />
        )}
      </LabeledList.Item>
      {recipe.products && (
        <LabeledList.Item bold label="Продукты">
          {recipe.products.map((product) => (
            <Button
              key={product.name}
              icon="vial"
              disabled={product.hasProduct}
              content={product.ratio + 'u ' + product.name}
              onClick={() =>
                act('reagent_click', {
                  id: product.id,
                })
              }
            />
          ))}
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="Реагенты">
        {recipe.reactants.map((reactant) => (
          <Box key={reactant.id}>
            <Button
              icon="vial"
              color={reactant.color}
              content={reactant.ratio + 'u ' + reactant.name}
              onClick={() =>
                act('reagent_click', {
                  id: reactant.id,
                })
              }
            />
            {!!reactant.tooltipBool && (
              <Button
                icon="flask"
                color="purple"
                tooltip={reactant.tooltip}
                tooltipPosition="right"
                onClick={() =>
                  act('find_reagent_reaction', {
                    id: reactant.id,
                  })
                }
              />
            )}
          </Box>
        ))}
      </LabeledList.Item>
      {recipe.catalysts && (
        <LabeledList.Item bold label="Катализаторы">
          {recipe.catalysts.map((catalyst) => (
            <Box key={catalyst.id}>
              {(catalyst.tooltipBool && (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + 'u ' + catalyst.name}
                  tooltip={catalyst.tooltip}
                  tooltipPosition={'right'}
                  onClick={() =>
                    act('reagent_click', {
                      id: catalyst.id,
                    })
                  }
                />
              )) || (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + 'u ' + catalyst.name}
                  onClick={() =>
                    act('reagent_click', {
                      id: catalyst.id,
                    })
                  }
                />
              )}
            </Box>
          ))}
        </LabeledList.Item>
      )}
      {recipe.reqContainer && (
        <LabeledList.Item bold label="Контейнер">
          <Button
            color="transparent"
            textColor="white"
            tooltipPosition="right"
            content={recipe.reqContainer}
            tooltip="Необходимый контейнер для проведения этой реакции."
          />
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="Чистота">
        <LabeledList>
          <LabeledList.Item label="Оптимальный диапазон рН">
            <Box position="relative">
              <Tooltip content="Если ваша реакция будет выдержана в этих пределах, то чистота вашего продукта будет на 100%">
                {recipe.lowerpH + '-' + recipe.upperpH}
              </Tooltip>
            </Box>
          </LabeledList.Item>
          {!!recipe.inversePurity && (
            <LabeledList.Item label="Обратная чистота">
              <Box position="relative">
                <Tooltip content="Если ваша чистота ниже этой, то при потреблении она на 100% преобразуется в соответствующий продукту обратный реагент.">
                  {`<${recipe.inversePurity * 100}%`}
                </Tooltip>
              </Box>
            </LabeledList.Item>
          )}
          {!!recipe.minPurity && (
            <LabeledList.Item label="Минимальная чистота">
              <Box position="relative">
                <Tooltip content="Если в какой-либо момент реакции уровень чистоты вашего продукта будет ниже этого значения, это приведет к негативным последствиям, а если по завершении он останется ниже этого значения, то превратится в соответствующий продукту неисправный реагент.">
                  {`<${recipe.minPurity * 100}%`}
                </Tooltip>
              </Box>
            </LabeledList.Item>
          )}
        </LabeledList>
      </LabeledList.Item>
      <LabeledList.Item bold label="Профиль ставок" width="10px">
        <Box
          height="50px"
          position="relative"
          style={{
            backgroundColor: 'black',
          }}
        >
          <Chart.Line
            fillPositionedParent
            data={recipe.thermodynamics}
            strokeWidth={0}
            fillColor={'#3cf072'}
          />
          {recipe.explosive && (
            <Chart.Line
              position="absolute"
              justify="right"
              top={0.01}
              bottom={0}
              right={recipe.isColdRecipe ? null : 0}
              width="28px"
              data={recipe.explosive}
              strokeWidth={0}
              fillColor={'#d92727'}
            />
          )}
        </Box>
        <Flex justify="space-between">
          <Tooltip
            content={
              recipe.isColdRecipe
                ? 'Температура, при которой он недогревается, оказывает негативное влияние на ход реакции.'
                : 'Минимальная температура, необходимая для начала реакции. Повышение температуры выше этой точки приведет к увеличению скорости реакции.'
            }
          >
            <Flex.Item
              position="relative"
              textColor={recipe.isColdRecipe && 'red'}
            >
              {recipe.isColdRecipe
                ? recipe.explodeTemp + 'K'
                : recipe.tempMin + 'K'}
            </Flex.Item>
          </Tooltip>

          {recipe.explosive && (
            <Tooltip
              content={
                recipe.isColdRecipe
                  ? 'Минимальная температура, необходимая для начала реакции. Повышение температуры выше этой точки приведет к увеличению скорости реакции.'
                  : 'Температура, при которой он перегревается, оказывает негативное влияние на ход реакции.'
              }
            >
              <Flex.Item
                position="relative"
                textColor={!recipe.isColdRecipe && 'red'}
              >
                {recipe.isColdRecipe
                  ? recipe.tempMin + 'K'
                  : recipe.explodeTemp + 'K'}
              </Flex.Item>
            </Tooltip>
          )}
        </Flex>
      </LabeledList.Item>
      <LabeledList.Item bold label="Динамика">
        <LabeledList>
          <LabeledList.Item label="Оптимальная скорость">
            <Tooltip content="Максимальная скорость, с которой может протекать реакция, в единицах измерения в секунду. Это область плато, показанная на графике скорости выше.">
              <Box position="relative">{recipe.thermoUpper + 'u/s'}</Box>
            </Tooltip>
          </LabeledList.Item>
        </LabeledList>
        <Tooltip content="Тепло, выделяемое в результате реакции, - экзотермическое выделяет тепло, эндотермическое потребляет тепло.">
          <Box position="relative">{recipe.thermics}</Box>
        </Tooltip>
      </LabeledList.Item>
    </LabeledList>
  );
};
