// <copyright file="StudentCode.cs" company="Pioneers in Engineering">
// Licensed to Pioneers in Engineering under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Pioneers in Engineering licenses 
// this file to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
// </copyright>

namespace StudentPiER
{
    using System;
    using PiE.HAL.GHIElectronics.NETMF.FEZ;
    using PiE.HAL.GHIElectronics.NETMF.Hardware;
    using PiE.HAL.Microsoft.SPOT;
    using PiE.HAL.Microsoft.SPOT.Hardware;
    using PiEAPI;

    /// <summary>
    /// Student Code template
    /// </summary>
    public class StudentCode : RobotCode
    {
        /// <summary>
        /// This is your robot
        /// </summary>
        private Robot robot;

        /// <summary>
        /// This stopwatch measures time, in seconds
        /// </summary>
        private Stopwatch stopwatch;

        /// <summary>
        /// The right drive motor, on connector M0
        /// </summary>
        private GrizzlyBear rightMotor;

        /// <summary>
        /// The left drive motor, on connector M1
        /// </summary>
        private GrizzlyBear leftMotor;

        //
        // Intake motor declarations on connector M2 and M3
        //

        private GrizzlyBear intakeLeftMotor;
        private GrizzlyBear intakeRightMotor;

        /// The pulley motors on connector M4 and M5
        
        private GrizzlyBear pulleyMotor;
    
        /// <summary>
        /// The sonar sensor on connector A5
        /// </summary>

        private AnalogSonarDistanceSensor sonar;

        /// <summary>
        /// Reflectance sensors on A0, A3
        /// </summary>
        private AnalogReflectanceSensor leftReflect;
        private AnalogReflectanceSensor rightReflect;


        /// <summary>
        /// The rfid sensor
        /// </summary>
        private Rfid rfid;

        /// <summary>
        ///   Initializes a new instance of the
        ///   <see cref="StudentPiER.StudentCode"/> class.
        /// </summary>
        /// <param name='robot'>
        ///   The Robot to associate with this StudentCode
        /// </param>
        public StudentCode(Robot robot)
        {
            this.robot = robot;
            this.stopwatch = new Stopwatch();
            this.stopwatch.Start();
            this.rfid = new Rfid(robot);
            this.leftMotor = new GrizzlyBear(robot, Watson.Motor.M0);
            this.rightMotor = new GrizzlyBear(robot, Watson.Motor.M1);
            this.intakeLeftMotor = new GrizzlyBear(robot, Watson.Motor.M2);
            this.intakeRightMotor = new GrizzlyBear(robot, Watson.Motor.M3);
            this.pulleyMotor = new GrizzlyBear(robot, Watson.Motor.M4);
            this.leftReflect = new AnalogReflectanceSensor(robot, Watson.Analog.A0);
            this.rightReflect = new AnalogReflectanceSensor(robot, Watson.Analog.A5);
            this.sonar = new AnalogSonarDistanceSensor(robot, Watson.Analog.A2);
        }

        /// <summary>
        /// Main method which initializes the robot, and starts
        /// it running. Do not modify.
        /// </summary>
        public static void Main()
        {
            // Initialize robot
            Robot robot = new Robot("1", "COM4");
            Debug.Print("Code loaded successfully!");
            Supervisor supervisor = new Supervisor(new StudentCode(robot));
            supervisor.RunCode();
        }

        /// <summary>
        ///  The Robot to use.
        /// </summary>
        /// <returns>
        ///   Robot associated with this StudentCode.
        /// </returns>
        public Robot GetRobot()
        {
            return this.robot;
        }

        /// <summary>
        /// The robot will call this method every time it needs to run the
        /// user-controlled student code
        /// The StudentCode should basically treat this as a chance to read all the
        /// new PiEMOS analog/digital values and then use them to update the
        /// actuator states
        /// </summary>

        public void TeleoperatedCode()
        {
       
            //
            // Connect the left and right joystick to the movement motors.
            //

            this.rightMotor.Throttle = this.robot.PiEMOSAnalogVals[1];
            this.leftMotor.Throttle = this.robot.PiEMOSAnalogVals[3];

            /*
            // alternate controls

            int leftAnalogStick2 = this.robot.PiEMOSAnalogVals[3];
            int rightAnalogStick = this.robot.PiEMOSAnalogVals[1];
            int leftAnalogStick = this.robot.PiEMOSAnalogVals[3];

            /// says if the left analog stick is pressed, then set the throttle values equal to the analog stick values
            
            if (leftAnalogStick2 > 0)
            {
                this.rightMotor.Throttle = leftAnalogStick2;
                this.leftMotor.Throttle = leftAnalogStick2;
            }

            /// if anything else happens, then it motors will be set to turn with the left and right analog stick
            
            else
            {
                this.rightMotor.Throttle = rightAnalogStick;
                this.leftMotor.Throttle = leftAnalogStick;
            }
            */
            ///sets the feedback analog values in PIEMOS for the motors
            
            this.robot.FeedbackAnalogVals[0] = this.rightMotor.Throttle;
            this.robot.FeedbackAnalogVals[1] = this.leftMotor.Throttle;

            //
            // Connect the intake IN to the right trigger.
            //

            int leftTrigger = this.robot.PiEMOSAnalogVals[5];
            int rightTrigger = this.robot.PiEMOSAnalogVals[4];

            /// If the right trigger is pressed, then the intake motors will go backwards (intake mechanism) and collect the boxes.

            if (rightTrigger > 0)
            {
                this.intakeRightMotor.Throttle = -rightTrigger;
                this.intakeLeftMotor.Throttle = -rightTrigger;
            }

            // at any other time, the motors will go forward by using the left trigger.

            else
            {
                this.intakeRightMotor.Throttle = leftTrigger;
                this.intakeLeftMotor.Throttle = leftTrigger;

            }

            /// the feedback analog values in piemos will be set to the intake motors.
           
            this.robot.FeedbackAnalogVals[2] = this.intakeLeftMotor.Throttle;
            this.robot.FeedbackAnalogVals[3] = this.intakeRightMotor.Throttle;

            ///creates two booleans that are set to the left and right thumb button.

            bool pulleyDown = this.robot.PiEMOSDigitalVals[4];
            bool pulleyUp = this.robot.PiEMOSDigitalVals[5];

            ///if the right thumb button is pressed and the left thumb button is not, then the pulley motor speed will be set to 50 (intake mechanism will go up).

            if (pulleyUp && !pulleyDown)
            {
                this.pulleyMotor.Throttle = 100;
            } 

            ///if the left thumb button is pressed, then the pulley motor speed will be set to -50 (intake mechanism will go down).
            
            else if (pulleyDown)
            {
                this.pulleyMotor.Throttle = -100;
            }

            /// in any other situation, the pulley motor speed will be 0.
            
            else 
            {
                this.pulleyMotor.Throttle = 0;
            }

            this.robot.FeedbackAnalogVals[6] = this.pulleyMotor.Throttle;
            this.robot.FeedbackAnalogVals[7] = this.pulleyMotor.Throttle;

            ///this will activate the Report Field Item Type code; aka will give the values that the RFID detects
             
            this.ReportFieldItemType(this.rfid.CurrentItemScanned);
          
        }

        /// <summary>
        /// The robot will call this method every time it needs to run the
        /// autonomous student code
        /// The StudentCode should basically treat this as a chance to change motors
        /// and servos based on non user-controlled input like sensors. But you
        /// don't need sensors, as this example demonstrates.
        /// </summary>
        /// 

        public void UserControlledCode()
        {

            //nothing
          

        }

        bool StartedTheStopwatch = false;

        public void AutonomousCode()
        {
            ///Displays text Autonomous and Reflectance sensor values
            
            Debug.Print("Autonomous");
            Debug.Print("/ L: " + leftReflect.Reflectance.ToString() + "/ R: " + rightReflect.Reflectance.ToString());
            /*
            // code for timed "autonomous" period of competition

            this.rightMotor.Throttle = 90;
            this.leftMotor.Throttle = 85;

            if (!StartedTheStopwatch)
            {
                StartedTheStopwatch = true;
                this.stopwatch.Start();
            }

            double CurrentTime = this.stopwatch.ElapsedTime;

            if (CurrentTime < 3)
            {
                this.rightMotor.Throttle = 0;
                this.leftMotor.Throttle = 0;
            }

            if (CurrentTime > 4.25 && CurrentTime < 4.7)
            {
                this.rightMotor.Throttle = 100;
                this.leftMotor.Throttle = -100;
            }

            if (CurrentTime > 6.50 && CurrentTime < 7.15)
            {
                this.rightMotor.Throttle = -100;
                this.leftMotor.Throttle = 100;
            }

            */
            
            int SPEED;
            
            ///Sets speed to value 50

            SPEED = 75;

            ///sets motors to speed int
            
            this.rightMotor.Throttle = SPEED;
            this.leftMotor.Throttle = SPEED;

            
            ///says if the left reflectance sensor is touching the line, turn left
            
            if (this.leftReflect.Reflectance > 95)
            {
                this.leftMotor.Throttle = -SPEED;
                this.rightMotor.Throttle = SPEED;
            }

            ///says if the right reflectance sensor is touching the line, turn right
            
            if (this.rightReflect.Reflectance > 95)
            {
                this.leftMotor.Throttle = SPEED;
                this.rightMotor.Throttle = -SPEED;
            }

            /// says if both right and left reflectance sensors are touching the line, go straight

            
            if ((this.rightReflect.Reflectance & this.leftReflect.Reflectance) > 95)
            { 
                this.leftMotor.Throttle = SPEED;
                this.rightMotor.Throttle = SPEED;
            }
            
            
            ///says if the sonar detects a distance less than 4, stops robot
            
            if (this.sonar.Distance < 4)
            {
                this.leftMotor.Throttle = 0;
                this.rightMotor.Throttle = 0;
            }
             
        }

        /// <summary>
        /// The robot will call this method periodically while it is disabled
        /// during the autonomous period. Actuators will not be updated during
        /// this time.
        /// </summary>
        public void DisabledAutonomousCode()
        {
            this.stopwatch.Restart(); // Restart stopwatch before start of autonomous
        }

        /// <summary>
        /// The robot will call this method periodically while it is disabled
        /// during the user controlled period. Actuators will not be updated
        /// during this time.
        /// </summary>
        public void DisabledTeleoperatedCode()
        {
        }

        /// <summary>
        /// This is called whenever the supervisor disables studentcode.
        /// </summary>
        public void WatchdogReset()
        {
        }

        /// <summary>
        /// Send the GroupType of a FieldItem object to PiEMOS.
        /// Populates two indices of FeedbackDigitalVals.
        /// </summary>
        /// <param name="item">the FieldItem to send infotmaion about</param>
        /// <param name="index1">first index to use</param>
        /// <param name="index2">second index to use</param>
        private void ReportFieldItemType(FieldItem item, int index1 = 6, int index2 = 7)
        {
            bool feedback1;
            bool feedback2;

            if (item == null)
            {
                feedback1 = false;
                feedback2 = false;
            }
            else if (item.GroupType == FieldItem.PlusOneBox)
            {
                feedback1 = true;
                feedback2 = false;
            }
            else if (item.GroupType == FieldItem.TimesTwoBox)
            {
                feedback1 = true;
                feedback2 = true;
            }
            else
            {
                feedback1 = false;
                feedback2 = true;
            }

            this.robot.FeedbackDigitalVals[index1] = feedback1;
            this.robot.FeedbackDigitalVals[index2] = feedback2;
        }
    }
}
