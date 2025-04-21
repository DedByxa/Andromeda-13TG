import {
  AnimatedNumber,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Beaker, BeakerSectionDisplay } from './common/BeakerDisplay';

const damageTypes = [
  {
    label: 'Физические',
    type: 'bruteLoss',
  },
  {
    label: 'Респираторные',
    type: 'oxyLoss',
  },
  {
    label: 'Токсины',
    type: 'toxLoss',
  },
  {
    label: 'Термические',
    type: 'fireLoss',
  },
] as const;

const stat_to_color = {
  Dead: 'bad',
  Conscious: 'bad',
  Unconscious: 'good',
} as const;

type Occupant = {
  name: string;
  stat: string;
  bodyTemperature: number;
  health: number;
  maxHealth: number;
  bruteLoss: number;
  oxyLoss: number;
  toxLoss: number;
  fireLoss: number;
};

type Data = {
  isOperating: BooleanLike;
  isOpen: BooleanLike;
  autoEject: BooleanLike;
  occupant: Occupant;
  T0C: number;
  cellTemperature: number;
  beaker: Beaker;
};

export const Cryo = () => {
  const { act, data } = useBackend<Data>();
  const { occupant, isOperating, isOpen } = data;

  return (
    <Window width={400} height={550}>
      <Window.Content scrollable>
        <Section title="В криокамере">
          <LabeledList>
            <LabeledList.Item label="Пациент">
              {occupant?.name || 'Никого нет'}
            </LabeledList.Item>
            {!!occupant && (
              <>
                <LabeledList.Item
                  label="Статус"
                  color={stat_to_color[occupant.stat]}
                >
                  {occupant.stat}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Температура"
                  color={occupant.bodyTemperature < data.T0C ? 'good' : 'bad'} // Green if the mob can actually be healed by cryoxadone.
                >
                  <AnimatedNumber value={round(occupant.bodyTemperature, 0)} />
                  {' K'}
                </LabeledList.Item>
                <LabeledList.Item label="Здоровье">
                  <ProgressBar
                    value={round(occupant.health / occupant.maxHealth, 2)}
                    color={occupant.health > 0 ? 'good' : 'average'}
                  >
                    <AnimatedNumber value={round(occupant.health, 0)} />
                  </ProgressBar>
                </LabeledList.Item>
                {damageTypes.map((damageType) => (
                  <LabeledList.Item
                    key={damageType.type}
                    label={damageType.label}
                  >
                    <ProgressBar
                      value={round(data.occupant[damageType.type] / 100, 2)}
                    >
                      <AnimatedNumber
                        value={round(data.occupant[damageType.type], 0)}
                      />
                    </ProgressBar>
                  </LabeledList.Item>
                ))}
              </>
            )}
          </LabeledList>
        </Section>
        <Section title="Криокамера">
          <LabeledList>
            <LabeledList.Item label="Питание">
              <Button
                icon={isOperating ? 'power-off' : 'times'}
                disabled={isOpen}
                onClick={() => act('power')}
                color={isOperating && 'green'}
              >
                {isOperating ? 'Вкл' : 'Выкл'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Temperature">
              <AnimatedNumber value={round(data.cellTemperature, 0)} /> K
            </LabeledList.Item>
            <LabeledList.Item label="Задвижка">
              <Button
                icon={isOpen ? 'unlock' : 'lock'}
                onClick={() => act('door')}
              >
                {isOpen ? 'Открыть' : 'Закрыть'}
              </Button>
              <Button
                icon={data.autoEject ? 'sign-out-alt' : 'sign-in-alt'}
                onClick={() => act('autoeject')}
              >
                {data.autoEject ? 'Авто' : 'В ручную'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <BeakerSectionDisplay beaker={data.beaker} showpH={false} />
      </Window.Content>
    </Window>
  );
};
