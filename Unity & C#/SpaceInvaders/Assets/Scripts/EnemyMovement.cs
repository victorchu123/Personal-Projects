using UnityEngine;
using System.Collections;

public class EnemyMovement : MonoBehaviour {

	int speed = 5;
	private int direction = 1;
	public int moveState = 0;
	private float timer = 0.0f;

	private bool justSwitched = false;
	

	// Use this for initialization
	void Start () {
		
	}

	// Update is called once per frame
	void Update () {

		if (moveState == 0){
			MoveLeftAndRight();
		}
		if(moveState == 1){
			MoveDown();
		}
	}

	//moves object left until wall is hit; same thing with right direction
	private void MoveLeftAndRight(){
		transform.Translate(Vector3.right * speed * direction* Time.deltaTime);
		justSwitched = false;
	}

	//moves object down every 0.6 secs
	private void MoveDown(){
		speed = 5;
		transform.Translate(Vector3.down * speed * Time.deltaTime);
		timer += Time.deltaTime;
		if(timer>0.5f){
			SwitchDirection();
		}
		else if (timer > 1.0f){
			speed = 10;
		}
	}

	//handles collision with a wall
	public void HitAWall(){
		if(moveState == 0 && !justSwitched){
			moveState = 1;
		}
		
	}

	//switches object's current moving direction
	private void SwitchDirection(){
		direction *= -1;
		timer = 0;
		justSwitched = true;
		moveState = 0;
	}
	

}
