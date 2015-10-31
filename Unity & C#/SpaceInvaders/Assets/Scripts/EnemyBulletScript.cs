using UnityEngine;
using System.Collections;

public class EnemyBulletScript : MonoBehaviour {

	private BasicMovement playerScript;


	// Use this for initialization
	void Start () {
		playerScript = GameObject.FindGameObjectWithTag("Player").GetComponent<BasicMovement>();
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate(Vector3.down *20* Time.deltaTime);
		if(Camera.main.WorldToViewportPoint(this.transform.position).y > 1){
			Destroy(this.gameObject);
		}
	}

	//handles bullet collision with player and platform
	void OnTriggerEnter(Collider other){
			if(other.GetComponent<Collider>().tag == "Player"){
				playerScript.LoseLives();
				other.GetComponent<AudioSource>().Play();
				Destroy (this.gameObject);
			}
			if(other.GetComponent<Collider>().tag == "Platform"){
				Destroy (other.gameObject);
				Destroy (this.gameObject);
			}
	 }
	
}
