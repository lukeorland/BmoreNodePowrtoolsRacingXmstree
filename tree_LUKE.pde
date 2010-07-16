// drag racing christmas tree controller
// Luke J Orland
// Thu Jul 15 23:00:43 EDT 2010

#define LED_ON  HIGH
#define LED_OFF LOW

enum
{
  RACE_STAGE_IDLE,
  RACE_STAGE_COUNTDOWN,
  RACE_STAGE_RACING,
  RACE_STAGE_POSTRACE,
};

enum
{
  COUNTDOWN_STEP_STAGE,
  COUNTDOWN_STEP_YELLOW_1,
  COUNTDOWN_STEP_YELLOW_2,
  COUNTDOWN_STEP_YELLOW_3,
  COUNTDOWN_STEP_GREEN,
  COUNTDOWN_STEP_RED,
  NUM_COUNTDOWN_STEPS,
};

enum
{
  LED_L_STAGE,
  LED_L_YELLOW_1,
  LED_L_YELLOW_2,
  LED_L_YELLOW_3,
  LED_L_GREEN,
  LED_L_RED,
  LED_R_STAGE,
  LED_R_YELLOW_1,
  LED_R_YELLOW_2,
  LED_R_YELLOW_3,
  LED_R_GREEN,
  LED_R_RED,
  NUM_TREE_LEDS,
};

/*** inputs ***/

#define PIN_IN_L_GAS 14
#define PIN_IN_L_END 15
#define PIN_IN_R_GAS 16
#define PIN_IN_R_END 17
#define PIN_IN_PRO_TREE  18

/*** outputs ***/

#define PIN_OUT_L_STAGE    12
#define PIN_OUT_L_YELLOW_1  2
#define PIN_OUT_L_YELLOW_2  4
#define PIN_OUT_L_YELLOW_3  6 
#define PIN_OUT_L_GREEN     8
#define PIN_OUT_L_RED      10

#define PIN_OUT_R_STAGE    13
#define PIN_OUT_R_YELLOW_1  3
#define PIN_OUT_R_YELLOW_2  5
#define PIN_OUT_R_YELLOW_3  7
#define PIN_OUT_R_GREEN     9
#define PIN_OUT_R_RED      11

// Mapping of Leds to output pins.
unsigned int treeLedPins[NUM_TREE_LEDS]=
{
  PIN_OUT_L_STAGE,
  PIN_OUT_L_YELLOW_1,
  PIN_OUT_L_YELLOW_2,
  PIN_OUT_L_YELLOW_3,
  PIN_OUT_L_GREEN,
  PIN_OUT_L_RED,
  PIN_OUT_R_STAGE,
  PIN_OUT_R_YELLOW_1,
  PIN_OUT_R_YELLOW_2,
  PIN_OUT_R_YELLOW_3,
  PIN_OUT_R_GREEN,
  PIN_OUT_R_RED,
};

void setup()
{                
  Serial.begin(9600);

  // initialize the output pins
  pinMode(PIN_OUT_L_STAGE, OUTPUT);     
  pinMode(PIN_OUT_L_YELLOW_1, OUTPUT);     
  pinMode(PIN_OUT_L_YELLOW_2, OUTPUT);     
  pinMode(PIN_OUT_L_YELLOW_3, OUTPUT);     
  pinMode(PIN_OUT_L_GREEN, OUTPUT);     
  pinMode(PIN_OUT_L_RED, OUTPUT);     
  pinMode(PIN_OUT_R_STAGE, OUTPUT);     
  pinMode(PIN_OUT_R_YELLOW_1, OUTPUT);     
  pinMode(PIN_OUT_R_YELLOW_2, OUTPUT);     
  pinMode(PIN_OUT_R_YELLOW_3, OUTPUT);     
  pinMode(PIN_OUT_R_GREEN, OUTPUT);     
  pinMode(PIN_OUT_R_RED, OUTPUT);     
  
  // initialize the input pins
  pinMode(PIN_IN_L_GAS, INPUT);
  pinMode(PIN_IN_L_END, INPUT);
  pinMode(PIN_IN_R_GAS, INPUT);
  pinMode(PIN_IN_R_END, INPUT);
  pinMode(PIN_IN_PRO_TREE, INPUT);

}

#define PERIOD_FOURTHENTHS_SECS (1000 * 4 / 10)

unsigned long sysTime = millis();

void loop()
{                
  sysTime = millis();
  static unsigned long lastTime = 0;
  static unsigned int countdownStep = COUNTDOWN_STEP_STAGE;
  unsigned int onLedLeft, onLedRight;
  
  if (sysTime >= lastTime + PERIOD_FOURTHENTHS_SECS)
  {
    lastTime = sysTime;
    switch (countdownStep)
    {
      case COUNTDOWN_STEP_STAGE:
        onLedLeft = LED_L_STAGE;
        onLedRight = LED_R_STAGE;
        break;
      case COUNTDOWN_STEP_YELLOW_1:
        onLedLeft = LED_L_YELLOW_1;
        onLedRight = LED_R_YELLOW_1;
        break;
      case COUNTDOWN_STEP_YELLOW_2:
        onLedLeft = LED_L_YELLOW_2;
        onLedRight = LED_R_YELLOW_2;
        break;
      case COUNTDOWN_STEP_YELLOW_3:
        onLedLeft = LED_L_YELLOW_3;
        onLedRight = LED_R_YELLOW_3;
        break;
      case COUNTDOWN_STEP_GREEN:
        onLedLeft = LED_L_GREEN;
        onLedRight = LED_R_GREEN;
        break;
      case COUNTDOWN_STEP_RED:
        onLedLeft = LED_L_RED;
        onLedRight = LED_R_RED;
        break;
    }
    for (int i = 0; i < NUM_TREE_LEDS; i++)
    {
      if ( i == onLedLeft || i == onLedRight )
      {
        digitalWrite(treeLedPins[i],LED_ON);
      }
      else
      {
        digitalWrite(treeLedPins[i],LED_OFF);
      }
    }
    if (++countdownStep >= NUM_COUNTDOWN_STEPS)
    {
      countdownStep = COUNTDOWN_STEP_STAGE;
    }
  }
}
