package UI 
{
	import UI.Draggable;
	/**
	 * ...
	 * @author 
	 */
	public class Instance extends UI.Draggable
	{
		//TODO: Lots of animation and tweens
		
		public function Instance(server:Object) 
		{
			name_txt.text = server.name;
			addresses_txt.text = "";
			
			for (var networkName:String in server.addresses)
			{
				addresses_txt.appendText("-" + networkName + "-\n")
				for each (var addressObj in server.addresses[networkName])
				{
					addresses_txt.appendText(addressObj.addr + "\n")
				}
			}
			
			//Reset scroll
			addresses_txt.scrollV = 0;
			addresses_txt.scrollH = 0;
			
			
			created_txt.text = server.created;
			zone_txt.text = server["OS-EXT-AZ:availability_zone"];
			state_txt.text = server["OS-EXT-STS:vm_state"];
			status_txt.text = server.status;
			
		}
		
	}

}