﻿using UnityEngine;
using System.Collections;

public class GameOver : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	//loads gameover scene in unity3d
	public void PlayAgain(){
		Application.LoadLevel("GameScene");
	}
}