// ConsoleApplication6.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>
#include <string>


using namespace std;
using std::string;

void readData(const string &, vector<double> &, vector<double> &);
double interpolation(double, const vector<double> &, const vector<double> &);
bool isOrdered(const vector<double> &);
void reorder(vector<double> &, vector<double> &);
void print(vector<double> &); //prints vector
double findMaxAngle(const vector<double> &); // gives the maximum angle of the data set (bounds)
double findMinAngle(const vector<double> &); // gives the minimum angle of the data set (bounds)


int main() {
	string data; //file name
	cout << "Enter name of input data file:" << endl;
	cin >> data;
	cout << endl;
	double numbers;
	int i = 0;
	ofstream createData;
	createData.open(data.c_str()); //allows you to enter data
	if (!createData.is_open()) {
		cout << "Error opening " << data << endl;
		return 1;
	}
	vector <double> flightAngle;
	vector <double> coeff;
	//cout << "Please enter data. Type end to stop entering data." << endl;
	while (cin >> numbers) { //number of data inputs
	   //cin >> numbers;
		createData << numbers << endl;
		i++;
	}
	createData.close();
	readData(data, flightAngle, coeff);

	double flightPath;
	double minAngle = findMinAngle(flightAngle);
	double maxAngle = findMaxAngle(flightAngle);
	cout << "The min angle is: " << minAngle << endl; //test to see if fcn works
	cout << "The max angle is: " << maxAngle << endl;

	cout << "Checking to see if the flight angles are in ascending order: " << boolalpha << isOrdered(flightAngle) << endl;
	if (!isOrdered(flightAngle)) {
		reorder(flightAngle, coeff);
		cout << "Flight angles are reordered in ascending order." << endl;
	}
	cout << "Checkign to see if the flight angles are in ascending order: " << isOrdered(flightAngle) << endl;

	cout << "Enter a flight path angle: " << endl;
	cin >> flightPath;
	int interpol = 0;
	if (flightPath <= maxAngle && flightPath >= minAngle) { //if it is within the bounds,
		cout << "The flight angle is within the bounds" << endl;
		interpol = interpolation(flightPath, flightAngle, coeff);
		cout << "The coresponding coefficient for flight Angle: " << flightPath << " is : " << interpol << endl;
	}
	else {
		cout << " the angle is not within the bounds " << endl;
	}

	return 0;
}

void print(vector<double> &v) {
	for (unsigned i = 0; i < v.size(); i++) {
		cout << v.at(i) << endl;
	}
}

void readData(const string &data, vector<double> &flightAngle, vector<double> &coeff) {
	double numb;
	ifstream readData;
	readData.open(data.c_str());
	if (!readData.is_open()) {
		cout << "Error opening " << data << endl;
		exit(1);
	}
	readData >> numb;
	if (readData.eof()) {
		cout << "Error opening " << data << endl;
		exit(1);
	}
	flightAngle.push_back(numb);
	int i = 1; //even or odd
	while (readData >> numb) {
		if (i % 2 == 0) {
			flightAngle.push_back(numb);
		}
		if (i % 2 == 1) {
			coeff.push_back(numb);
		}
		i++;
	}
	readData.close();
	cout << "flihgt angle vec: " << endl;
	print(flightAngle);
	cout << "coeff vec: " << endl;
	print(coeff);
}

double findMaxAngle(const vector<double> &flightAngle) {
	double maxAngle = flightAngle.at(0);
	for (unsigned i = 0; i < flightAngle.size(); i++) {
		if (maxAngle <= flightAngle.at(i)) {
			maxAngle = flightAngle.at(i);
		}
	}
	return maxAngle;
}

double findMinAngle(const vector<double> &flightAngle) {
	double minAngle = flightAngle.at(0);
	for (unsigned i = 0; i < flightAngle.size(); i++) {
		if (minAngle >= flightAngle.at(i)) {
			minAngle = flightAngle.at(i);
		}
	}
	return minAngle;
}
//steps: check if it is ordered; if not, reorder; maybe check it again
//f(b) = f(a) + ((b - a)/(c - a))(f(c) - f(a)) should do this last
double interpolation(double flightPath, const vector<double> &flightAngle, const vector<double> &coeff) {
	double wantedCoeff = 0.0; //using the asked flight path
	for (unsigned i = 0; i < flightAngle.size(); i++) {
		if (flightPath == flightAngle.at(i)) {
			return coeff.at(i);  //if the flightPath requested = a providedc flightAngle, return coressponding coeff
		}
	}

	for (unsigned i = 0; i < flightAngle.size(); i++) {
		if ((flightPath > flightAngle.at(i))) {//&& (flightPath < flightPath.at(i+1))){
			cout << i;
			wantedCoeff = coeff.at(i) + ((flightPath - flightAngle.at(i)) / (flightAngle.at(i + 1) - flightAngle.at(i))) * (coeff.at(i + 1) - coeff.at(i));
		}
	}
	return wantedCoeff;
}

bool isOrdered(const vector<double> &flightAngle) {
	bool isAscend = true;
	for (unsigned i = 0; i + 1 < flightAngle.size(); i++) {
		if (!(flightAngle.at(i) <= flightAngle.at(i + 1))) {
			isAscend = false;
		}
	}
	return isAscend;
}

void reorder(vector<double> &flightAngle, vector<double> &coeff) {
	//double temp;
	for (unsigned j = 0; j < flightAngle.size(); j++) {
		for (unsigned i = 0; i + 1 < flightAngle.size(); i++) {
			if (flightAngle.at(i) >= flightAngle.at(i + 1)) {
				swap(flightAngle.at(i), flightAngle.at(i + 1));
				swap(coeff.at(i), coeff.at(i + 1));

			}
		}
	}
	//cout << "the reordered is: " << endl;
	//cout << "Flight angles: " << endl;
	//print (flightAngle);
	//cout << "coeff :" << endl;
	//print (coeff);
}

