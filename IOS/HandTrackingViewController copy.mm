// Copyright 2019 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "HandTrackingViewController.h"

#include "mediapipe/framework/formats/landmark.pb.h"

static const char* kLandmarksOutputStream = "hand_landmarks";

@implementation HandTrackingViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.mediapipeGraph addFrameOutputStream:kLandmarksOutputStream
                           outputPacketType:MPPPacketTypeRaw];
}

#pragma mark - MPPGraphDelegate methods

// Receives a raw packet from the MediaPipe graph. Invoked on a MediaPipe worker thread.
- (void)mediapipeGraph:(MPPGraph*)graph
     didOutputPacket:(const ::mediapipe::Packet&)packet
          fromStream:(const std::string&)streamName {
  if (streamName == kLandmarksOutputStream) {
    if (packet.IsEmpty()) {
      NSLog(@"[TS:%lld] No hand landmarks", packet.Timestamp().Value());
      return;
    }
    const auto& landmarks = packet.Get<::mediapipe::NormalizedLandmarkList>();
    //NSLog(@"Number of landmarks on hand: %d", landmarks.landmark_size());
     // if () {
      //    [handState setString:@"Yes hand"];
    //   NSLog(@"%@", handState);
    //  } else {
    //      [handState setString:@"No hand"];
    //      NSLog(@"%@", handState);
    //  }
    //NSLog(@"[TS:%lld] Number of landmarks on hand: %d", packet.Timestamp().Value(),
    //     landmarks.landmark_size());
      
    //for (int i = 0; i < landmarks.landmark_size(); ++i) {
    //  NSLog(@"\tLandmark[%d]: (%f, %f, %f)", i, landmarks.landmark(i).x(),
    //        landmarks.landmark(i).y(), landmarks.landmark(i).z());
    //}
    //NSLog(@"\tLandmark[%d]: (%f, %f, %f)", 0, landmarks.landmark(0).x(),
    //      landmarks.landmark(0).y(), landmarks.landmark(0).z());

    NSMutableString *handState = [[NSMutableString alloc] initWithFormat:@""];
    bool thumbIsOpen = false;
    bool firstFingerIsOpen = false;
    bool secondFingerIsOpen = false;
    bool thirdFingerIsOpen = false;
    bool fourthFingerIsOpen = false;

    float pseudoFixKeyPoint = landmarks.landmark(2).x();
    if (landmarks.landmark(3).x() < pseudoFixKeyPoint && landmarks.landmark(4).x() < pseudoFixKeyPoint)
    {
      thumbIsOpen = true;
    }
      
    pseudoFixKeyPoint = landmarks.landmark(6).y();
    if (landmarks.landmark(7).y() < pseudoFixKeyPoint && landmarks.landmark(8).y() < pseudoFixKeyPoint)
    {
      firstFingerIsOpen = true;
    }

    pseudoFixKeyPoint = landmarks.landmark(10).y();
    if (landmarks.landmark(11).y() < pseudoFixKeyPoint && landmarks.landmark(12).y() < pseudoFixKeyPoint)
    {
      secondFingerIsOpen = true;
    }

    pseudoFixKeyPoint = landmarks.landmark(14).y();
    if (landmarks.landmark(15).y() < pseudoFixKeyPoint && landmarks.landmark(16).y() < pseudoFixKeyPoint)
    {
      thirdFingerIsOpen = true;
    }

    pseudoFixKeyPoint = landmarks.landmark(18).y();
    if (landmarks.landmark(19).y() < pseudoFixKeyPoint && landmarks.landmark(20).y() < pseudoFixKeyPoint)
    {
      fourthFingerIsOpen = true;
    }
    
    
    // Hand gesture recognition
    if (thumbIsOpen && firstFingerIsOpen && secondFingerIsOpen && thirdFingerIsOpen && fourthFingerIsOpen)
    {
        NSLog(@"%@", @"FIVE");
    }
    else if (!thumbIsOpen && firstFingerIsOpen && secondFingerIsOpen && thirdFingerIsOpen && fourthFingerIsOpen)
    {
        NSLog(@"%@", @"FOUR");
    }
    else if (thumbIsOpen && firstFingerIsOpen && secondFingerIsOpen && !thirdFingerIsOpen && !fourthFingerIsOpen)
    {
        NSLog(@"%@", @"THREE");
    }
    else if (thumbIsOpen && firstFingerIsOpen && !secondFingerIsOpen && !thirdFingerIsOpen && !fourthFingerIsOpen)
    {
        NSLog(@"%@", @"TWO");
    }
    else if (!thumbIsOpen && firstFingerIsOpen && !secondFingerIsOpen && !thirdFingerIsOpen && !fourthFingerIsOpen)
    {
        NSLog(@"%@", @"ONE");
    }
    else if (!thumbIsOpen && firstFingerIsOpen && secondFingerIsOpen && !thirdFingerIsOpen && !fourthFingerIsOpen)
    {
        NSLog(@"%@", @"YEAH");
    }
    else if (!thumbIsOpen && firstFingerIsOpen && !secondFingerIsOpen && !thirdFingerIsOpen && fourthFingerIsOpen)
    {
        NSLog(@"%@", @"ROCK");
    }
    else if (thumbIsOpen && firstFingerIsOpen && !secondFingerIsOpen && !thirdFingerIsOpen && fourthFingerIsOpen)
    {
        NSLog(@"%@", @"SPIDERMAN");
    }
//    else if (!thumbIsOpen && !firstFingerIsOpen && !secondFingerIsOpen && !thirdFingerIsOpen && !fourthFingerIsOpen)
//    {
//        NSLog(@"%@", @"FIST");
//    }
    else
    {
        NSLog (@"Finger States: %@ %@ %@ %@ %@", thumbIsOpen, firstFingerIsOpen, secondFingerIsOpen, thirdFingerIsOpen, fourthFingerIsOpen);
    }
      
//    if (landmarks.landmark(0).x()!=0 && landmarks.landmark(0).y()!=0 ) {
//           [handState setString:@"Yes hand"];
//            NSLog(@"%@", handState);
//       } else {
//           [handState setString:@"No hand"];
//           NSLog(@"%@", handState);
//       }
  }
}

@end
