using UnityEngine;
using System.Collections;

public class BossBulletScript : MonoBehaviour {
	public bool bossAlive = true;
	//private int bossLives = 3;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate(Vector3.up * 20 * Time.deltaTime);
		if(Camera.main.WorldToViewportPoint(this.transform.position).y > 1){
			Destroy (this.gameObject);
		}
		/*if(bossLives == 0){
			bossAlive = false;
		}*/
	}

	void OnTriggerEnter(Collider other){
	
		if(other.GetComponent<Collider>().tag == "Boss"){
			Destroy(this.gameObject);
			Destroy(other.gameObject);
			bossAlive = false;
		}
		if(other.GetComponent<Collider>().tag == "Platform"){
			Destroy (other.gameObject);
			Destroy (this.gameObject);
		}
			/*bossLives--;
			Destroy (this.gameObject);
		}
		if (bossAlive == false){
			Destroy(this.gameObject);
			Destroy(other.gameObject);
		}*/
		
	}
}
