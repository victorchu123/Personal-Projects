using UnityEngine;
using System.Collections;

public class BossBulletScript : MonoBehaviour {
	public bool bossAlive = true;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate(Vector3.up * 20 * Time.deltaTime);
		if(Camera.main.WorldToViewportPoint(this.transform.position).y > 1){
			Destroy (this.gameObject);
		}
	}

	//handles collision with the larger space invader or the platform object
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
	}
}
