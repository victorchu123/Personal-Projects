using UnityEngine;
using System.Collections;

public class ScreenCollision : MonoBehaviour {
	
	public EnemyMovement moverScript; 

	// Use this for initialization
	void Start () {
	
	}

	// Update is called once per frame
	void Update () {
		//checks when an object hit the "wall" based on the viewport bounds
		float boundsCheck = Camera.main.WorldToViewportPoint(this.transform.position).x;
		if(boundsCheck > 0.95f || boundsCheck < 0.05f){
			moverScript.HitAWall();
		}
	}
}
