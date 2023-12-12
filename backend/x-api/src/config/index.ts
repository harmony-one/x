import * as process from 'process';

const parseBoolean = (value = '1') => {
  if (['true', 'false'].includes(value)) {
    return value === 'true';
  }
  return Boolean(+value);
};

export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
});
