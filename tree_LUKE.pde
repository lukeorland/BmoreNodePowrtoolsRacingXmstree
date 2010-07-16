// drag racing christmas tree controller
// Luke J Orland
// Thu Jul 15 23:00:43 EDT 2010

// All times values are defined as quantity of milliseconds.

enum
{
  RACE_STATE_READY,     // Waiting for both racers to check in by pressing 
                        // the pedal momentarily. When both have pressed
                        // their pedal switch, stage lights turn on
                        // --> RACE_STATE_STAGE_LIGHTS

  RACE_STATE_STAGE_LIGHTS, // Leave the stage lights on for a random amount of
                           // time between 5 to 10 seconds. When time is up,
                           // start the countdown.
                           // --> RACE_STATE_COUNTDOWN


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
  INPUT_L_GAS,      // Momentary On foot switch
  INPUT_R_GAS,      // Momentary On foot switch

  INPUT_L_END,      // IR phototransistor to detect
                    // IR beam broken as racer comes
                    // through finish line
  INPUT_R_END,

  INPUT_READY,      // Normally closed momentary switch
                    // to manually advance the state 
                    // machine.
  
  INPUT_PRO_TREE,   // Not yet implemented.
                    // When high, "Pro Tree"-style countdown
                    // When low, "Competion Tree"-style countdown
  NUM_INPUTS,
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
#define PIN_IN_L_GAS         3
#define PIN_IN_L_END         4
#define PIN_IN_R_GAS         5
#define PIN_IN_R_END         6
#define PIN_IN_READY         7
#define PIN_IN_PRO_TREE      8 // No functionality yet.

// Output pins
#define PIN_OUT_L_STAGE      9
#define PIN_OUT_L_YELLOW_1   10
#define PIN_OUT_L_YELLOW_2   11
#define PIN_OUT_L_YELLOW_3   12 
#define PIN_OUT_L_GREEN      13
#define PIN_OUT_L_RED        14

#define PIN_OUT_R_STAGE      15
#define PIN_OUT_R_YELLOW_1   16
#define PIN_OUT_R_YELLOW_2   17
#define PIN_OUT_R_YELLOW_3   18
#define PIN_OUT_R_GREEN      19
#define PIN_OUT_R_RED        20

#define PIN_OUT_L_POWERTOOL  21
#define PIN_OUT_R_POWERTOOL  22

// Mapping of input pins to Input indices.
unsigned int inputPins[NUM_INPUTS]=
{
  PIN_IN_L_GAS,
  PIN_IN_L_END,
  PIN_IN_R_GAS,
  PIN_IN_R_END,
  PIN_IN_READY,
  PIN_IN_PRO_TREE,
};

int inputStateFlags; // This variable stores the input
                     // states in a bit field
                     // representation using the 
                     // Input indices as bit positions.

int newInputFlags;   // Set the bit for newly engaged 
                     // inputs.

// Mapping of output pins to Led indices.
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

#define PERIOD_400_MILLIS (1000 * 4 / 10)
#define PERIOD_SWITCH_DEBOUNCE (1000 / 20)

unsigned long sysTime;

void KillLeds()
{
  for (int i = 0; i < NUM_TREE_LEDS; i++)
  {
    digitalWrite(treeLedPins[i],LED_OFF);
  }
}

// State machine definitions for race stages

unsigned int raceState, raceSubState;
boolean isLeftPowertoolActive, isRightPowertoolActive;
unsigned long raceStartTime;

void SetNewState(int newState)
{
  raceState = newState;
  raceSubState = 0;
}

void DoStateReady()
{
}

void DoStateStageLights()
{
}

void DoStateCountdown()
{
  static unsigned long lastTime = 0;
  static unsigned int countdownStep = COUNTDOWN_STEP_STAGE;
  unsigned int onLedLeft, onLedRight;
  
  if (sysTime >= lastTime + PERIOD_400_MILLIS)
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
  // If either false started, set corresponding isLeftPowertoolActive or
  // isRightPowertoolActive to false.
  // if both are false, go to RACE_STATE_READY
  // otherwise, go to RACE_STATE_RACING.
}

void DoStateRacing()
{
  static boolean hasLeftCompleted, hasRightCompleted;
  static boolean hasLeftStarted, hasRightStarted;
  static unsigned long reactionTimeLeft, reactionTimeRight;
  static unsigned long completionTimeLeft, completionTimeRight;
  char * report;

  if (raceSubState == 0)
  {
    hasLeftCompleted = false;
    hasRightCompleted = false;
    raceSubState++;
  }

  if (raceSubState == 1)
  {
    // Kill the Race if the ready switch is pressed to call
    // the race early.
    if (newInputFlags & (1 << INPUT_READY))
    {
      // Red lights
      digitalWrite(treeLedPins[LED_R_GREEN], LED_OFF);
      digitalWrite(treeLedPins[LED_R_RED], LED_ON);
      digitalWrite(treeLedPins[LED_L_GREEN], LED_OFF);
      digitalWrite(treeLedPins[LED_L_RED], LED_ON);

      // Kill powertools
      digitalWrite(PIN_OUT_L_POWERTOOL, POWERTOOL_OFF);
      digitalWrite(PIN_OUT_R_POWERTOOL, POWERTOOL_OFF);
      SetNewState(RACE_STATE_POSTRACE);
      return;
    }
    // Handle left and right racers separately
    if (isLeftPowertoolActive && !hasLeftCompleted)
    {
      // Pedal switch engaged?
      if (inputStateFlags & (1 << INPUT_L_GAS))
      {
        if (!hasLeftStarted)
        {
          hasLeftStarted = true;
          // record the Left's reaction time
          // once it finally gets started.
          reactionTimeLeft = sysTime - raceStartTime;
        }

        // Pedal is engaged, so turn on powertool.
        digitalWrite(PIN_OUT_L_POWERTOOL,POWERTOOL_ON);

        // Finish line reached?
        if (inputStateFlags & (1 << INPUT_L_END))
        {
          // Stop the left powertool.
          digitalWrite(PIN_OUT_L_POWERTOOL,POWERTOOL_OFF);
          hasLeftCompleted = true; // deactivate this tool.
          // Record finish time.
          completionTimeLeft = sysTime - raceStartTime;
          
          // Turn Left lights from green to red.
          digitalWrite(treeLedPins[LED_L_GREEN],LED_OFF);
          digitalWrite(treeLedPins[LED_L_RED],LED_ON);
        }
      }
      else
      {
        // Turn off powertool if pedal switch is not closed.
        digitalWrite(PIN_OUT_L_POWERTOOL,POWERTOOL_OFF);
      }
    }

    // Right's turn
    if (isRightPowertoolActive && !hasRightCompleted)
    {
      // Pedal switch engaged?
      if (inputStateFlags & (1 << INPUT_R_GAS))
      {
        if (!hasRightStarted)
        {
          hasRightStarted = true;
          // record the Right's reaction time
          // once it finally gets started.
          reactionTimeRight = sysTime - raceStartTime;
        }

        // Pedal is engaged, so turn on powertool.
        digitalWrite(PIN_OUT_R_POWERTOOL,POWERTOOL_ON);

        // Finish line reached?
        if (inputStateFlags & (1 << INPUT_R_END))
        {
          // Stop the powertool.
          digitalWrite(PIN_OUT_R_POWERTOOL,POWERTOOL_OFF);
          hasRightCompleted = true; // deactivate this tool.
          // Record finish time.
          completionTimeRight = sysTime - raceStartTime;
          
          // Turn Right lights from green to red.
          digitalWrite(treeLedPins[LED_R_GREEN],LED_OFF);
          digitalWrite(treeLedPins[LED_R_RED],LED_ON);
        }
      }
      else
      {
        // Turn off powertool if pedal switch is not closed.
        digitalWrite(PIN_OUT_R_POWERTOOL,POWERTOOL_OFF);
      }
    }

    // Both tools done/inactive?
    if ((!isLeftPowertoolActive || hasLeftCompleted)
        && (!isRightPowertoolActive || hasRightCompleted))
    {
      raceState++;
    }
  }

  if (raceSubState == 2)
  {
    if (isLeftPowertoolActive && hasLeftCompleted)
    {
      sprintf(report, "\nThe LEFT racer had a reaction time of %i ms and finished in %i\n", reactionTimeLeft, completionTimeLeft);
      Serial.print(report);
    }
    if (isRightPowertoolActive && hasRightCompleted)
    {
      sprintf(report, "The RIGHT racer had a reaction time of %i ms and finished in %i", reactionTimeRight, completionTimeRight);
      Serial.print(report);
    }
    // Leave both left and right red lights and go to RACE_STATE_POSTRACE.
    SetNewState(RACE_STATE_POSTRACE);
  }
}

void DoStatePostrace()
{
  // If the ready switch just got newly pressed
  if ( newInputFlags & (1 << INPUT_READY) )
  {
    SetNewState(RACE_STATE_READY);
    KillLeds();
  }
}

void setup()
{                
  Serial.begin(9600);

  // initialize the output pins
  // Turn everything off.
  for (int i = 0; i < NUM_TREE_LEDS; i++)
  {
    pinMode(treeLedPins[i],OUTPUT);
  }
  KillLeds();

  pinMode(PIN_OUT_L_POWERTOOL, OUTPUT);     
  pinMode(PIN_OUT_R_POWERTOOL, OUTPUT);     

  digitalWrite(PIN_OUT_L_POWERTOOL,POWERTOOL_OFF);
  digitalWrite(PIN_OUT_R_POWERTOOL,POWERTOOL_OFF);

  // Initialize the input pins.
  // Enable internal pullup resistors.
  for (int i = 0; i < NUM_TREE_LEDS; i++)
  {
    pinMode(inputPins[i], INPUT);
    digitalWrite(inputPins[i],LED_OFF);
  }
}

void loop()
{                
  static long lastSwitchTime;
  static int lastInputStateFlags;

  raceState = RACE_STATE_POSTRACE;

  digitalWrite(PIN_OUT_L_RED, LED_ON);     
  digitalWrite(PIN_OUT_R_RED, LED_ON);     

  while (true)
  {
    sysTime = millis();

    // Check switch inputs
    inputStateFlags = 0;
    if (sysTime >= lastSwitchTime + PERIOD_SWITCH_DEBOUNCE)
    {
      for (int i = 0; i < NUM_INPUTS; i++)
      {
        if (digitalRead(inputPins[i]) == LOW)
        {
          lastInputStateFlags = inputStateFlags;
          // LOW state indicates switch is engaged,
          // so set the flag.
          inputStateFlags |= (1 << i);
        }
      }
    }

    newInputFlags = inputStateFlags & (lastInputStateFlags ^ inputStateFlags);

    random(); // randomize

    // State machine
    switch (raceState)
    {
      case RACE_STATE_READY:
        DoStateReady();
        break;
      case RACE_STATE_STAGE_LIGHTS:
        DoStateStageLights();
        break;
      case RACE_STATE_COUNTDOWN:
        DoStateCountdown();
        break;
      case RACE_STATE_RACING:
        DoStateRacing();
        break;
      case RACE_STATE_POSTRACE:
        DoStatePostrace();
        break;
    }
  }
}
