import { sortBy } from 'common/collections';
import {
  Box,
  Button,
  Flex,
  ProgressBar,
  Section,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const JOB_REPORT_MENU_FAIL_REASON_TRACKING_DISABLED = 1;
const JOB_REPORT_MENU_FAIL_REASON_NO_RECORDS = 2;

const sortByPlaytime = (array) => sortBy(array, ([_, playtime]) => -playtime);

const PlaytimeSection = (props) => {
  const { playtimes } = props;

  const sortedPlaytimes = sortByPlaytime(Object.entries(playtimes)).filter(
    (entry) => entry[1],
  );

  if (!sortedPlaytimes.length) {
    return 'Для этого раздела не записаны часы воспроизведения.';
  }

  const mostPlayed = sortedPlaytimes[0][1];
  return (
    <Table>
      {sortedPlaytimes.map(([jobName, playtime]) => {
        const ratio = playtime / mostPlayed;
        return (
          <Table.Row key={jobName}>
            <Table.Cell
              collapsing
              p={0.5}
              style={{
                verticalAlign: 'middle',
              }}
            >
              <Box align="right">{jobName}</Box>
            </Table.Cell>
            <Table.Cell>
              <ProgressBar maxValue={mostPlayed} value={playtime}>
                <Flex>
                  <Flex.Item width={`${ratio * 100}%`} />
                  <Flex.Item>
                    {(playtime / 60).toLocaleString(undefined, {
                      minimumFractionDigits: 1,
                      maximumFractionDigits: 1,
                    })}
                    h
                  </Flex.Item>
                </Flex>
              </ProgressBar>
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  );
};

export const TrackedPlaytime = (props) => {
  const { act, data } = useBackend();
  const {
    failReason,
    jobPlaytimes,
    specialPlaytimes,
    exemptStatus,
    isAdmin,
    livingTime,
    ghostTime,
    adminTime,
  } = data;
  return (
    <Window title="Игровые часы" width={550} height={650}>
      <Window.Content scrollable>
        {(failReason &&
          ((failReason === JOB_REPORT_MENU_FAIL_REASON_TRACKING_DISABLED && (
            <Box>На этом сервере отключено отслеживание.</Box>
          )) ||
            (failReason === JOB_REPORT_MENU_FAIL_REASON_NO_RECORDS && (
              <Box>У вас нет никаких записей.</Box>
            )))) || (
          <Box>
            <Section title="Всё">
              <PlaytimeSection
                playtimes={{
                  Ghost: ghostTime,
                  Living: livingTime,
                  Admin: adminTime,
                }}
              />
            </Section>
            <Section
              title="Должность"
              buttons={
                !!isAdmin && (
                  <Button.Checkbox
                    checked={!!exemptStatus}
                    onClick={() => act('toggle_exempt')}
                  >
                    Следить за временем
                  </Button.Checkbox>
                )
              }
            >
              <PlaytimeSection playtimes={jobPlaytimes} />
            </Section>
            <Section title="Особый">
              <PlaytimeSection playtimes={specialPlaytimes} />
            </Section>
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};
