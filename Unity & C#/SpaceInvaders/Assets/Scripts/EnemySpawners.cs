using UnityEngine;
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
	public BasicMovement BM;

	private bool hasActiveObjects (){
		GameObject[] allObjects = UnityEngine.Object.FindObjectsOfType<GameObject>();
		foreach(GameObject go in allObjects){
			if (go.activeInHierarchy){
				return true;
			}
		}
		return false;
	}

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		//random enemy spawner when player is still alive
		if(newBS.playerAlive == true){

			// spawns a normal space invader every 1.1 secs
			if(count < 5){
				timer += Time.deltaTime;
				if(timer > 1.0f){
					newX = (float)Random.Range(-15,30)+ 3.0f;
					newY = (float)Random.Range (20,30)+ 1.0f;
					randPos = new Vector3(newX, newY, -20);
					Instantiate(SpaceInvader, randPos, Quaternion.identity);
					timer = 0.0f;
					count++;
				}
			}
			// once 4 groups are spawned, a boss is spawned with 5 space invaders every 11 secs
			// spawns 4 total groups and then stops
			else if(count >= 5 && count <=8){

				timer += Time.deltaTime;
				if(timer > 10.0f){
					newX = (float)Random.Range(-15,30)+ 3.0f;
					newY = (float)Random.Range (15,20)+1.0f;
					randPos = new Vector3(newX, newY, -20);
					Instantiate(Boss, randPos, Quaternion.identity);

					for(int i = 0; i< 5; i++){
						newX = (float)Random.Range(-15,30)+ 2.0f;
						newY = (float)Random.Range (20,30)+ 1.5f;
						randPos2 = new Vector3(newX, newY, -20);
						Instantiate(SpaceInvader, randPos2, Quaternion.identity);
					}
					timer = 0.0f;
					count++;
				}
			}else if (count > 8){
				if ((newBS.playerAlive == true) && (BM.score == 500) ){
					Application.LoadLevel("WinMenu");
				}
			}
				
		}
	}
}
