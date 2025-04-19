import { createDropdownInput, Feature } from '../base';

export const pixel_size: Feature<number> = {
  name: 'Масштабирование пикселей',
  category: 'ИНТЕРФЕЙС',
  component: createDropdownInput({
    0: 'Растянуть до нужного',
    1: 'Пиксель к Пикселю 1x',
    1.5: 'Пиксель к Пикселю 1.5x',
    2: 'Пиксель к Пикселю 2x',
    3: 'Пиксель к Пикселю 3x',
    4: 'Пиксель к Пикселю 4x',
    4.5: 'Пиксель к Пикселю 4.5x',
    5: 'Пиксель к Пикселю 5x',
  }),
};
