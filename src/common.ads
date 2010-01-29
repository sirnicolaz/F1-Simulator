package Common is
   type PERCENTAGE is delta 0.01 range 0.0..100.0;
   type DRIVING_STYLE is (AGGRESSIVE,NORMAL,CONSERVATIVE);
   type COMPETITORS_LIST is array(INTEGER range <>) of INTEGER;
end Common;
