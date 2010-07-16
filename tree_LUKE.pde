// drag racing christmas tree controller
// Luke J Orland
// Thu Jul 15 23:00:43 EDT 2010

enum
{
  RACE_STATE_READY,     // Red Light on, waiting for ready switch from race
                        // official.
                        // When ready switch gets pressed, turn on all lights
                        // for one second.

  RACE_STATE_STAGE_LIGHTS, // Watch inputs for gas pedals indicating each racer
                           // is ready.

  RACE_STATE_COUNTDOWN, // Manage christmas tree countdown,
                        // watch gas pedals for false start. If racer false
                        // starts, her red light turns on and her gas pedal
                        // does not start car.
                        // --> RACE_STATE_RACING

                        // If both racers false start,
                        // --> RACE_STATE_READY

  RACE_STATE_RACING,    // Watch gas pedals to throw relay (start vehicle)
                        // for each racer.
                        // Watch for both racers to finish or kill switch.
                        // --> RACE_STATE_POSTRACE

  RACE_STATE_POSTRACE,  // Red Light on, waiting for ready switch from race
                        // official. When ready switch is pressed, flash all 
                        // lights momentarily, the turn them all off.
                        // --> RACE_STATE_READY
  NUM_RACE_STATES,
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

#define LED_ON  HIGH
#define LED_OFF LOW

#define POWERTOOL_ON  HIGH
#define POWERTOOL_OFF LOW

// Input pins
#define PIN_IN_L_GAS          3
#define PIN_IN_L_END          4
#define PIN_IN_R_GAS          5
#define PIN_IN_R_END          6
#define PIN_IN_PRO_TREE       7

// Output pins
#define PIN_OUT_L_STAGE       8
#define PIN_OUT_L_YELLOW_1    9
#define PIN_OUT_L_YELLOW_2    10
#define PIN_OUT_L_YELLOW_3    11 
#define PIN_OUT_L_GREEN       12
#define PIN_OUT_L_RED         13

#define PIN_OUT_R_STAGE       14
#define PIN_OUT_R_YELLOW_1    15
#define PIN_OUT_R_YELLOW_2    16
#define PIN_OUT_R_YELLOW_3    17
#define PIN_OUT_R_GREEN       18
#define PIN_OUT_R_RED         19

#define PIN_OUT_L_POWERTOOL   20
#define PIN_OUT_R_POWERTOOL   21

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
  pinMode(PIN_OUT_L_POWERTOOL, OUTPUT);     
  pinMode(PIN_OUT_R_POWERTOOL, OUTPUT);     
  
  // Turn everything off.
  for (int i = 0; i < NUM_TREE_LEDS; i++)
  {
    digitalWrite(treeLedPins[i],LED_OFF);
  }

  digitalWrite(PIN_OUT_L_POWERTOOL,POWERTOOL_OFF);
  digitalWrite(PIN_OUT_R_POWERTOOL,POWERTOOL_OFF);

  // Initialize the input pins.
  pinMode(PIN_IN_L_GAS, INPUT);
  pinMode(PIN_IN_L_END, INPUT);
  pinMode(PIN_IN_R_GAS, INPUT);
  pinMode(PIN_IN_R_END, INPUT);
  pinMode(PIN_IN_PRO_TREE, INPUT);

  // Enable internal pullup resistors.
  digitalWrite(PIN_IN_L_GAS,HIGH);
  digitalWrite(PIN_IN_L_END,HIGH);
  digitalWrite(PIN_IN_R_GAS,HIGH);
  digitalWrite(PIN_IN_R_END,HIGH);
  digitalWrite(PIN_IN_PRO_TREE,HIGH);
}

#define PERIOD_FOURTHENTHS_SECS (1000 * 4 / 10)

unsigned long sysTime;

void DoStateIdle()
{
}

void DoStateCountdown()
{
}

void DoStateRacing()
{
}

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
