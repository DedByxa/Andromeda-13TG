import { useContext } from 'react';
import {
  Button,
  Icon,
  ProgressBar,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { capitalizeFirst, toTitleCase } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { OrbitContext } from '.';
import { HEALTH, VIEWMODE } from './constants';
import { getDepartmentByJob, getDisplayName } from './helpers';
import { JobIcon } from './JobIcon';
import { OrbitData } from './types';

/** Slide open menu with more info about the current observable */
export function OrbitBlade(props) {
  const { data } = useBackend<OrbitData>();
  const { orbiting } = data;

  const { setBladeOpen, realNameDisplay, setRealNameDisplay } =
    useContext(OrbitContext);

  return (
    <Stack vertical width="244px">
      <Stack.Item>
        <Section
          buttons={
            <Button
              color="bad"
              icon="times"
              onClick={() => setBladeOpen(false)}
            />
          }
          color="label"
          title="Настройки слежки"
        >
          Имейте в виду: слежка не обновляется автоматически. Вам необходимо
          нажать кнопку &quot;Обновить&quot; чтобы увидеть последние данные.
        </Section>
      </Stack.Item>
      <Stack.Item>
        <ViewModeSelector />
      </Stack.Item>
      <Stack.Item>
        <Section
          buttons={
            <Button
              color="transparent"
              icon="passport"
              selected={realNameDisplay}
              onClick={() => setRealNameDisplay(!realNameDisplay)}
            />
          }
          color="label"
          title="Отображение реального имени"
        >
          В режиме «Реальные имена» будут отображаться реальные имена
          персонажей. Чтобы не основываться на информации их ID карты.
        </Section>
      </Stack.Item>
      {!!orbiting && (
        <Stack.Item>
          <OrbitInfo />
        </Stack.Item>
      )}
    </Stack>
  );
}

function ViewModeSelector(props) {
  const { viewMode, setViewMode } = useContext(OrbitContext);

  return (
    <Section title="Режим просмотра">
      <Stack fill vertical>
        <Stack.Item color="label">
          Измените цвет и схему сортировки наблюдаемых мобов или предметов.
        </Stack.Item>

        {Object.entries(VIEWMODE).map(([key, value]) => (
          <Button
            align="center"
            color="transparent"
            fluid
            icon={value}
            key={key}
            onClick={() => setViewMode(value)}
            selected={value === viewMode}
          >
            {key}
          </Button>
        ))}
      </Stack>
    </Section>
  );
}

function OrbitInfo(props) {
  const { data } = useBackend<OrbitData>();

  const { orbiting } = data;
  if (!orbiting) return;

  const { name, full_name, health, job } = orbiting;

  let department;
  if ('job' in orbiting && !!job) {
    department = getDepartmentByJob(job);
  }

  let showAFK;
  if ('client' in orbiting && !orbiting.client) {
    showAFK = true;
  }

  return (
    <Section title="Слежка">
      <Stack fill vertical>
        <Stack.Item>
          {toTitleCase(getDisplayName(full_name, name))}
          {showAFK && (
            <Tooltip content="Away from keyboard" position="bottom-start">
              <Icon ml={1} color="grey" name="bed" />
            </Tooltip>
          )}
        </Stack.Item>

        {!!job && (
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <JobIcon item={orbiting} realNameDisplay={false} />
              </Stack.Item>
              <Stack.Item color="label" grow>
                {job}
              </Stack.Item>
              {!!department && (
                <Stack.Item color="grey">
                  {capitalizeFirst(department)}
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        )}
        {health !== undefined && (
          <Stack.Item>
            <HealthDisplay health={health} />
          </Stack.Item>
        )}

        <Stack.Item />
      </Stack>
    </Section>
  );
}

function HealthDisplay(props: { health: number }) {
  const { health } = props;

  let icon = 'heart';
  let howDead;
  switch (true) {
    case health <= HEALTH.Ruined:
      howDead = `Very Dead: ${health}`;
      icon = 'skull';
      break;
    case health <= HEALTH.Dead:
      howDead = `Dead: ${health}`;
      icon = 'heart-broken';
      break;
    case health <= HEALTH.Crit:
      howDead = `Health critical: ${health}`;
      icon = 'tired';
      break;
    case health <= HEALTH.Bad:
      howDead = `Bad: ${health}`;
      icon = 'heartbeat';
      break;
  }

  return (
    <Stack align="center">
      <Stack.Item>
        <Icon color="grey" name={icon} />
      </Stack.Item>
      <Stack.Item color={howDead && 'bad'} grow>
        {howDead || (
          <ProgressBar
            maxValue={100}
            minValue={0}
            ranges={{
              good: [70, Infinity],
              average: [20, HEALTH.Good],
              bad: [0, HEALTH.Average],
            }}
            value={health}
          />
        )}
      </Stack.Item>
    </Stack>
  );
}
