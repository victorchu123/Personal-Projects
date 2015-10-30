﻿using UnityEngine;
using System.Collections;

public class EnemySpawners : MonoBehaviour {

	public EnemyBulletScript newBS; 
	public GameObject SpaceInvader;
	public GameObject Boss;
	private float timer = 0.0f;
	private Vector3 randPos;
	private Vector3 randPos2;
	private float newX; 
	private float newY;
	private int count = 0;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

	
		if(newBS.playerAlive == true){
			if(count < 5){
				timer += Time.deltaTime;
				if(timer > 1.0f){
					newX = (float)Random.Range(-15,30)+ 1.1f;
					newY = (float)Random.Range (20,30)+ 0.8f;
					randPos = new Vector3(newX, newY, -20);
					Instantiate(SpaceInvader, randPos, Quaternion.identity);
					timer = 0.0f;
					count++;
				}
			}
			else if(count >= 5 && count <=8){
				timer += Time.deltaTime;
				if(timer > 10.0f){
					newX = (float)Random.Range(-15,30)+ 1.1f;
					newY = (float)Random.Range (15,20)+0.8f;
					randPos = new Vector3(newX, newY, -20);
					Instantiate(Boss, randPos, Quaternion.identity);

					for(int i = 0; i< 5; i++){
						newX = (float)Random.Range(-15,30)+ 1.1f;
						newY = (float)Random.Range (20,30)+ 0.8f;
						randPos2 = new Vector3(newX, newY, -20);
						Instantiate(SpaceInvader, randPos2, Quaternion.identity);
					}
					timer = 0.0f;
					count++;
				}
			}
			else{

			}
		}
	}
}
