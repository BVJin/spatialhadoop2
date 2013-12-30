/*
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements. See the
 * NOTICE file distributed with this work for additional information regarding copyright ownership. The ASF
 * licenses this file to you under the Apache License, Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

package edu.umn.cs.spatialHadoop.nasa;


/**
 * Projects a NASAPoint in HDF file from Sinusoidal projection to Mercator
 * projection.
 * @author Ahmed Eldawy
 *
 */
public class MercatorProjector extends LatLonProjector {
  
  @Override
  public void projectPoint(NASAPoint pt) {
    super.projectPoint(pt);
    // Use the Mercator projection to draw an image similar to Google Maps
    // http://stackoverflow.com/questions/14329691/covert-latitude-longitude-point-to-a-pixels-x-y-on-mercator-projection
    double latRad = pt.y * Math.PI / 180.0;
    double mercN = Math.log(Math.tan(Math.PI/4-latRad/2));
    pt.y = -180 * mercN / Math.PI;
    //int imageY = (int) (((double) imageHeight / 2) - (imageWidth * mercN / (2 * (fileMBR.getHeight() * Math.PI / 180.0))));
  }
  
  public static void main(String[] args) {
    NASAPoint pt = new NASAPoint(0, -80, 0);
    MercatorProjector proj = new MercatorProjector();
    proj.projectPoint(pt);
    System.out.println(pt);
  }
}
