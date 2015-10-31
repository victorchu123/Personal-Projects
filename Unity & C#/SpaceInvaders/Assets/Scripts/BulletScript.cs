using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class BulletScript : MonoBehaviour {
	public bool enemyAlive = true;
	private BasicMovement playerScript;


	//public bool bossAlive = true;
	//private int bossLives = 3;

	// Use this for initialization
	void Start () {
		playerScript = GameObject.FindGameObjectWithTag("Player").GetComponent<BasicMovement>();
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate(Vector3.up *20* Time.deltaTime);
		if(Camera.main.WorldToViewportPoint(this.transform.position).y > 1){
			Destroy(this.gameObject);
		}
	}

	//handles collision for when bullet collides with space invaders;
	void OnTriggerEnter(Collider other){
		if(other.GetComponent<Collider>().tag == "Enemy"){
			if(enemyAlive){
				Destroy (other.gameObject);
				Destroy (this.gameObject);
				enemyAlive = false;
				playerScript.gainMinScore();
			}
		}
		if(other.GetComponent<Collider>().tag == "Boss"){
			Destroy (other.gameObject);
			Destroy (this.gameObject);
			enemyAlive = false;
			playerScript.gainMaxScore();
		}	

	}
}
